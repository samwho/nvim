-- Writing support for Markdown and MDX.

vim.pack.add { 'https://github.com/mfussenegger/nvim-lint' }

local lint = require 'lint'
local spell_namespace = vim.api.nvim_create_namespace 'writing-spell'
local spellfile = vim.fs.joinpath(vim.fn.stdpath 'config', 'spell', 'en.utf-8.add')
vim.fn.mkdir(vim.fs.dirname(spellfile), 'p')

local function blank_range(value, start_col, end_col)
  local region = value:sub(start_col, end_col):gsub('[^ \t]', ' ')
  return value:sub(1, start_col - 1) .. region .. value:sub(end_col + 1)
end

local function find_jsx_tag_end(line, start_col, continuing)
  local quote
  local brace_depth = 0
  local first_col = start_col + (continuing and 0 or 1)
  for col = first_col, #line do
    local char = line:sub(col, col)
    if quote then
      if char == quote and line:sub(col - 1, col - 1) ~= '\\' then quote = nil end
    elseif char == '"' or char == "'" then
      quote = char
    elseif char == '{' then
      brace_depth = brace_depth + 1
    elseif char == '}' and brace_depth > 0 then
      brace_depth = brace_depth - 1
    elseif char == '>' and brace_depth == 0 then
      return col
    end
  end
end

local function mask_non_prose(line, in_jsx_tag)
  local masked = line
  local cursor = 1

  while cursor <= #line do
    local start_col = in_jsx_tag and cursor or line:find('<[>/A-Za-z]', cursor)
    if not start_col then break end

    local end_col = find_jsx_tag_end(line, start_col, in_jsx_tag)
    if not end_col then return blank_range(masked, start_col, #line), true end

    masked = blank_range(masked, start_col, end_col)
    cursor = end_col + 1
    in_jsx_tag = false
  end

  for _, pattern in ipairs { '`[^`]*`', 'https?://%S+', '{[^}]*}' } do
    masked = masked:gsub(pattern, function(region) return region:gsub('[^ \t]', ' ') end)
  end
  return masked, in_jsx_tag
end

local function update_spell_diagnostics(bufnr)
  local diagnostics = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local in_fence = false
  local in_jsx_tag = false
  local in_frontmatter = lines[1] and lines[1]:match '^%s*---%s*$' ~= nil

  for row, line in ipairs(lines) do
    if in_frontmatter then
      if row > 1 and line:match '^%s*---%s*$' then in_frontmatter = false end
      goto continue
    end
    if row == 1 and line:match '^%s*---%s*$' then goto continue end

    local fence = line:match '^%s*```' or line:match '^%s*~~~'
    if fence then
      in_fence = not in_fence
      goto continue
    end
    if in_fence or line:match '^%s%s%s%s' or line:match '^%s*\t' then goto continue end

    local prose
    prose, in_jsx_tag = mask_non_prose(line, in_jsx_tag)
    for start_col, word, end_col in prose:gmatch("()([%a][%a'%-]*)()") do
      local bad = vim.fn.spellbadword(word)
      if bad[1] ~= '' then
        table.insert(diagnostics, {
          lnum = row - 1,
          end_lnum = row - 1,
          col = start_col - 1,
          end_col = end_col - 1,
          message = 'Spelling: ' .. bad[1],
          source = 'spell',
          code = bad[2],
          severity = vim.diagnostic.severity.WARN,
        })
      end
    end

    ::continue::
  end

  vim.diagnostic.set(spell_namespace, bufnr, diagnostics)
end

local function add_spelling_diagnostic_to_dictionary(bufnr)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  for _, diagnostic in ipairs(vim.diagnostic.get(bufnr, { lnum = row - 1 })) do
    if diagnostic.namespace == spell_namespace and col >= diagnostic.col and col < diagnostic.end_col then
      local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ''
      local word = line:sub(diagnostic.col + 1, diagnostic.end_col)
      vim.cmd.spellgood { args = { word } }
      update_spell_diagnostics(bufnr)
      return
    end
  end

  vim.notify('Place the cursor on a spelling diagnostic first', vim.log.levels.INFO)
end

-- Vale does not parse .mdx unless the optional mdx2vast executable is installed.
-- Treat MDX as Markdown instead, which still checks its prose and avoids linting
-- JSX as prose syntax.
local severities = {
  error = vim.diagnostic.severity.ERROR,
  warning = vim.diagnostic.severity.WARN,
  information = vim.diagnostic.severity.INFO,
  hint = vim.diagnostic.severity.HINT,
  suggestion = vim.diagnostic.severity.HINT,
}

local function parse_mdx_vale(output, bufnr)
  if vim.trim(output) == '' then return {} end

  local diagnostics = {}
  local results = vim.json.decode(output)['stdin.md'] or {}
  for _, item in pairs(results) do
    local line = vim.api.nvim_buf_get_lines(bufnr, item.Line - 1, item.Line, false)[1] or ''
    local ok, column = pcall(vim.str_byteindex, line, item.Span[1])
    if not ok then column = 1 end
    local ok_end, end_column = pcall(vim.str_byteindex, line, item.Span[2])
    if not ok_end then end_column = #line end

    table.insert(diagnostics, {
      lnum = item.Line - 1,
      end_lnum = item.Line - 1,
      col = column - 1,
      end_col = end_column,
      message = item.Message,
      source = 'vale',
      code = item.Check,
      severity = assert(severities[item.Severity], 'missing mapping for severity ' .. item.Severity),
    })
  end
  return diagnostics
end

lint.linters.vale_mdx = vim.deepcopy(lint.linters.vale)
lint.linters.vale_mdx.args = { '--no-exit', '--output', 'JSON', '--ext', '.md' }
lint.linters.vale_mdx.parser = parse_mdx_vale

lint.linters_by_ft = {
  markdown = { 'vale' },
  mdx = { 'vale_mdx' },
}

local prose_filetypes = {
  markdown = true,
  mdx = true,
}

local writing_group = vim.api.nvim_create_augroup('writing', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = writing_group,
  pattern = { 'markdown', 'mdx' },
  callback = function(args)
    -- MDX's Tree-sitter injections make Vim's native scanner see JSX identifiers
    -- as prose, so MDX relies on the filtered diagnostic scanner instead.
    vim.opt_local.spell = vim.bo[args.buf].filetype ~= 'mdx'
    vim.opt_local.spelllang = { 'en_gb' }
    vim.opt_local.spellfile = spellfile
    vim.keymap.set('n', '<leader>d', 'z=', { buffer = args.buf, desc = 'Show spelling suggestions' })
    vim.keymap.set('n', '<leader>D', function() add_spelling_diagnostic_to_dictionary(args.buf) end, {
      buffer = args.buf,
      desc = 'Add spelling diagnostic to dictionary',
    })
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = writing_group,
  callback = function(args)
    if not prose_filetypes[vim.bo[args.buf].filetype] then return end
    update_spell_diagnostics(args.buf)
    if vim.fn.executable 'vale' == 1 then lint.try_lint() end
  end,
})
