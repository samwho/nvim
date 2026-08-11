--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- ============================================================
-- SECTION 1: OPTIONS
-- Core Neovim settings, leaders, options
-- ============================================================
do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
  vim.g.mapleader = ','
  vim.g.maplocalleader = ' '

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true

  -- [[ Setting options ]]
  --  See `:help vim.o`
  -- NOTE: You can change these options as you wish!
  --  For more options, you can see `:help option-list`

  -- Make line numbers default
  vim.o.number = true
  -- You can also add relative line numbers, to help with jumping.
  --  Experiment for yourself to see if you like it!
  -- vim.o.relativenumber = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.o.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Enable break indent
  vim.o.breakindent = true

  -- Enable undo/redo changes even after closing and reopening a file
  vim.o.undofile = true

  -- Reload files changed on disk when the buffer is clean. A modified buffer
  -- is handled by the FileChangedShell autocmd below.
  vim.o.autoread = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep the sign column reserved so diagnostics do not shift the buffer
  vim.o.signcolumn = 'yes'

  -- Show a guide where lines reach 80 characters.
  vim.o.colorcolumn = '80'

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  --
  --  Notice listchars is set using `vim.opt` instead of `vim.o`.
  --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
  --   See `:help lua-options`
  --   and `:help lua-guide-options`
  vim.o.list = true
  vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live, as you type!
  vim.o.inccommand = 'split'

  -- Show which line your cursor is on
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 10

  -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
  -- instead raise a dialog asking if you wish to save the current file(s)
  -- See `:help 'confirm'`
  vim.o.confirm = true
end

-- Keep hover windows readable even when a language server includes huge
-- inline data-URI images (for example, MDN's embedded SVG icons).
local lsp_hover_options = {
  border = 'rounded',
  title = ' Hover ',
  title_pos = 'center',
  max_width = 80,
  max_height = 15,
  wrap = true,
  focusable = true,
  focus = true,
  -- Keep the hover open while moving through it; <Esc> closes it explicitly.
  close_events = {},
}

local function show_hover_or_diagnostic()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  local has_diagnostic = false

  for _, diagnostic in ipairs(vim.diagnostic.get(0, { lnum = row })) do
    local start_col = diagnostic.col or 0
    local end_col = math.max(diagnostic.end_col or start_col + 1, start_col + 1)
    local severity = diagnostic.severity
    local is_error_or_warning = severity == vim.diagnostic.severity.ERROR or severity == vim.diagnostic.severity.WARN
    if is_error_or_warning and col >= start_col and col < end_col then
      has_diagnostic = true
      break
    end
  end

  if has_diagnostic then
    vim.diagnostic.open_float { scope = 'cursor', focus = false }
  elseif #vim.lsp.get_clients { bufnr = 0 } > 0 then
    vim.lsp.buf.hover(vim.tbl_extend('force', {}, lsp_hover_options))
  else
    vim.notify('No active LSP client for this buffer', vim.log.levels.INFO)
  end
end

local function configure_hover_window(bufnr, win)
  if not bufnr or not win or not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(win) then return end

  vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', {
    buffer = bufnr,
    silent = true,
    nowait = true,
    desc = 'Close hover window',
  })
  vim.api.nvim_set_current_win(win)
end

-- `vim.lsp.buf.hover()` opens previews asynchronously and does not focus a new
-- float itself. Wrap the preview helper so this also works on Neovim versions
-- where the hover request bypasses the deprecated global hover handler.
local lsp_open_floating_preview = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
  local bufnr, win = lsp_open_floating_preview(contents, syntax, opts)
  if opts and opts.focus_id == 'textDocument/hover' then configure_hover_window(bufnr, win) end
  return bufnr, win
end

local lsp_convert_input_to_markdown_lines = vim.lsp.util.convert_input_to_markdown_lines
local function strip_inline_data_images(value)
  if type(value) == 'string' then
    return (value:gsub('!%[[^]]*%]%(%s*data:image/[^)]*%)', ''))
  end
  if type(value) == 'table' then
    local copy = {}
    for key, item in pairs(value) do
      copy[key] = strip_inline_data_images(item)
    end
    return copy
  end
  return value
end
vim.lsp.util.convert_input_to_markdown_lines = function(contents, ...)
  return lsp_convert_input_to_markdown_lines(strip_inline_data_images(contents), ...)
end

-- ============================================================
-- SECTION 2: KEYMAPS & AUTOCMDS
-- basic keymaps, basic autocmds
-- ============================================================
do
  -- Inline diagnostics with wrapping, so long messages remain visible without
  -- requiring the cursor to be moved onto the diagnostic line.
  vim.pack.add { 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' }
  require('tiny-inline-diagnostic').setup {
    preset = 'minimal',
    transparent_bg = true,
    options = {
      softwrap = 30,
      show_source = { enabled = false },
      show_code = false,
      add_messages = {
        messages = true,
        display_count = false,
      },
      multilines = {
        enabled = true,
        always_show = true,
      },
    },
  }

  -- [[ Basic Keymaps ]]
  --  See `:help vim.keymap.set()`

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Move by screen line so wrapped prose does not skip over visible lines.
  vim.keymap.set({ 'n', 'x' }, 'j', 'gj', { desc = 'Move down by display line' })
  vim.keymap.set({ 'n', 'x' }, 'k', 'gk', { desc = 'Move up by display line' })

  local function copy_file_reference(start_line, end_line)
    local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
    if file == '' then file = '[No Name]' end

    local reference = end_line and string.format('%s:%d-%d', file, start_line, end_line)
      or string.format('%s:%d', file, start_line)
    vim.fn.setreg('+', reference)
  end

  -- Copy a visual selection as a file and line-range reference for Pi.
  vim.keymap.set('x', '<leader>y', function()
    -- In a visual-mode mapping, the `<`/`>` marks may not have been updated
    -- yet. Use the live visual anchor and cursor instead.
    local start_line = vim.fn.line 'v'
    local end_line = vim.fn.line '.'
    if start_line > end_line then start_line, end_line = end_line, start_line end
    copy_file_reference(start_line, end_line)
  end, { desc = 'Copy file/line reference' })

  -- With no visual selection, copy just the current file and line.
  vim.keymap.set('n', '<leader>y', function() copy_file_reference(vim.fn.line '.') end, { desc = 'Copy file/line reference' })

  -- Diagnostic Config & Keymaps
  --  See `:help vim.diagnostic.Opts`
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '●',
        [vim.diagnostic.severity.WARN] = '●',
        [vim.diagnostic.severity.INFO] = '●',
        [vim.diagnostic.severity.HINT] = '●',
      },
    },
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- tiny-inline-diagnostic renders wrapped messages; disable Neovim's
    -- competing built-in renderers.
    virtual_text = false,
    virtual_lines = false,

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }

  -- Make LSP hover documentation compact and readable. `vim.lsp.buf.hover`
  -- opens the preview directly on recent Neovim versions, so the options are
  -- also passed explicitly in the mapping below.
  vim.lsp.handlers['textDocument/hover'] = function(err, result, ctx, config)
    config = vim.tbl_deep_extend('force', config or {}, lsp_hover_options)
    local bufnr, win = vim.lsp.handlers.hover(err, result, ctx, config)
    configure_hover_window(bufnr, win)
    return bufnr, win
  end

  -- `gh` is Select mode by default. Make the hover mapping global so it also
  -- works before LspAttach fires (and does not unexpectedly enter Select mode).
  vim.keymap.set('n', 'gh', show_hover_or_diagnostic, { desc = 'Show hover or diagnostic' })

  vim.keymap.set('n', 'gl', function()
    vim.diagnostic.open_float {
      scope = 'cursor',
      focus = false,
      border = 'rounded',
      max_width = 100,
      max_height = 15,
      wrap = true,
    }
  end, { desc = 'Show full diagnostic' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- TIP: Disable arrow keys in normal mode
  -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  local function move_focus(direction)
    local previous_window = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(direction)

    -- `wincmd` is intentionally a no-op at the edge of the window layout.
    -- A terminal cannot receive a key back from Neovim, so this cannot be
    -- transparently bubbled to Ghostty from here.
    return vim.api.nvim_get_current_win() ~= previous_window
  end

  vim.keymap.set('n', '<C-h>', function() move_focus 'h' end, { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', function() move_focus 'l' end, { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', function() move_focus 'j' end, { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', function() move_focus 'k' end, { desc = 'Move focus to the upper window' })

  -- Shift+HJKL provides a quicker directional alternative for split navigation.
  -- Use the literal uppercase keys: terminals normally send <S-l> as `L`.
  vim.keymap.set('n', 'H', function() move_focus 'h' end, { desc = 'Move focus to the left window' })
  vim.keymap.set('n', 'L', function() move_focus 'l' end, { desc = 'Move focus to the right window' })
  vim.keymap.set('n', 'J', function() move_focus 'j' end, { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', 'K', function() move_focus 'k' end, { desc = 'Move focus to the upper window' })

  -- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
  -- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
  -- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
  -- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
  -- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  -- Detect external edits promptly. Clean buffers are reloaded automatically
  -- via 'autoread'; modified buffers get a synchronous choice so the decision
  -- is made while Neovim is handling the FileChangedShell event.
  local external_file_changes = vim.api.nvim_create_augroup('external-file-changes', { clear = true })
  vim.api.nvim_create_autocmd('FileChangedShell', {
    group = external_file_changes,
    callback = function(args)
      if vim.v.fcs_reason ~= 'conflict' then
        vim.v.fcs_choice = 'edit'
        return
      end

      local name = vim.fn.fnamemodify(args.file, ':~:.')
      local choice = vim.fn.confirm(
        ('%s\n\nChanged on disk while this buffer has unsaved changes.'):format(name),
        '&Keep buffer\n&Reload from disk',
        1
      )

      -- Leaving v:fcs_choice empty keeps the in-memory buffer. Choosing edit
      -- reloads the file and updates its encoding/fileformat detection.
      if choice == 2 then vim.v.fcs_choice = 'edit' end
    end,
  })

  vim.api.nvim_create_autocmd({ 'FocusGained', 'CursorHold', 'CursorHoldI' }, {
    group = external_file_changes,
    callback = function() vim.cmd 'checktime' end,
  })
end

-- ============================================================
-- SECTION 3: PLUGIN MANAGER INTRO
-- vim.pack intro, build hooks
-- ============================================================
do
  -- [[ Intro to `vim.pack` ]]
  -- `vim.pack` is a new plugin manager built into Neovim,
  --  which provides a Lua interface for installing and managing plugins.
  --
  --  See `:help vim.pack`, `:help vim.pack-examples` or the
  --  excellent blog post from the creator of vim.pack and mini.nvim:
  --  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
  --
  --  To inspect plugin state and pending updates, run
  --    :lua vim.pack.update(nil, { offline = true })
  --
  --  To update plugins, run
  --    :lua vim.pack.update()
  --
  --
  --  Throughout the rest of the config there will be examples
  --  of how to install and configure plugins using `vim.pack`.
  --
  --  In this section we set up some autocommands to run build
  --  steps for certain plugins after they are installed or updated.

  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  -- This autocommand runs after a plugin is installed or updated and
  --  runs the appropriate build command for that plugin if necessary.
  --
  -- See `:help vim.pack-events`
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SECTION 4: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
do
  -- [[ Installing and Configuring Plugins ]]
  --
  -- To install a plugin simply call `vim.pack.add` with its git url.
  -- This will download the default branch of the plugin, which will usually be `main` or `master`
  -- You can also have more advanced specs, which we will talk about later.
  --
  -- For most plugins its not enough to install them, you also need to call their `.setup()` to start them.
  --
  -- For example, lets say we want to install `guess-indent.nvim` - a plugin for
  -- automatically detecting and setting the indentation.
  --
  -- We first install it from https://github.com/NMAC427/guess-indent.nvim
  -- and then call its `setup()` function to start it with default settings.
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- Here is a more advanced configuration example that passes options to `gitsigns.nvim`
  --
  -- See `:help gitsigns` to understand what each configuration key does.
  -- Show git changes by highlighting line numbers, without adding a gutter column.
  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  local gitsigns = require 'gitsigns'
  gitsigns.setup {
    signcolumn = true,
    numhl = false,
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '▁' },
      topdelete = { text = '▔' },
      changedelete = { text = '┋' },
      untracked = { text = '┆' },
    },
  }

  -- Native signs only occupy the first screen row of a wrapped line. Render
  -- gitsigns through statuscolumn instead; Neovim evaluates it for every
  -- screen row, so the Git marker continues through wrapped text. Fall back
  -- to the native sign item so diagnostic signs remain visible elsewhere.
  _G.gitsigns_statuscolumn = function()
    local sign = gitsigns.statuscolumn()
    return sign:match '%S' and sign or '%s'
  end
  vim.o.statuscolumn = '%C%{%v:lua.gitsigns_statuscolumn()%}%=%{%v:virtnum > 0 ? "" : "%l"%}'

  -- Gitsigns defaults to greedy navigation, which re-runs the full diff when
  -- 'diffopt' includes linematch. Use the already-cached hunks instead.
  -- Neovim's built-in `gcc` comment mapping is a longer prefix of `gc` and
  -- forces a timeout before navigation can run, so remove that conflicting
  -- normal-mode mapping. Keep `gc` silent so the key sequence is not echoed.
  pcall(vim.keymap.del, 'n', 'gcc')
  vim.keymap.set('n', 'gc', function() gitsigns.nav_hunk('next', { greedy = false }) end, { desc = '[G]it next [C]hange', nowait = true, silent = true })
  vim.keymap.set('n', 'gC', function() gitsigns.nav_hunk('prev', { greedy = false }) end, { desc = '[G]it previous [C]hange' })

  -- Character-level inline Git diff highlighting, toggled on demand.
  vim.pack.add { gh 'YouSame2/inlinediff-nvim' }
  local inlinediff = require 'inlinediff'
  inlinediff.setup {
    colors = {
      InlineDiffAddContext = '#263b27',
      InlineDiffAddChange = '#4d7535',
      InlineDiffDeleteContext = '#3b2525',
      InlineDiffDeleteChange = '#733b3b',
    },
  }
  vim.keymap.set('n', '<leader>d', function() inlinediff.toggle() end, { desc = 'Toggle inline diff' })

  -- Decorated scrollbar with diagnostics, search, Git hunks, and marks.
  vim.pack.add { gh 'lewis6991/satellite.nvim' }
  require('satellite').setup {}

  -- Code outline for classes, methods, functions, and other symbols.
  -- Aerial uses Tree-sitter when available and falls back to LSP symbols.
  vim.pack.add { gh 'stevearc/aerial.nvim' }
  require('aerial').setup {
    backends = { 'treesitter', 'lsp', 'markdown' },
    layout = {
      default_direction = 'prefer_left',
      placement = 'edge',
      min_width = 28,
      max_width = { 40, 0.2 },
      resize_to_content = true,
    },
    -- Aerial installs buffer-local H/L and Ctrl-J/Ctrl-K mappings for tree
    -- navigation. Remove those overrides so the global split-focus mappings
    -- also work while the Aerial window is focused.
    keymaps = {
      H = false,
      J = false,
      K = false,
      L = false,
      ['<C-j>'] = false,
      ['<C-k>'] = false,
    },
    show_guides = true,
    -- Return to the source buffer after selecting a symbol.
    close_on_select = true,
  }
  -- Without the bang, Aerial focuses the outline when it opens.
  vim.keymap.set('n', '<leader>o', '<cmd>AerialToggle<CR>', { desc = 'Toggle code outline' })

  -- IDE-like breadcrumbs in the winbar for the current symbol context.
  vim.pack.add { gh 'Bekaboo/dropbar.nvim' }
  require('dropbar').setup {}

  -- Side-by-side Git diff review when needed.
  vim.pack.add { gh 'sindrets/diffview.nvim' }
  local diffview_actions = require 'diffview.actions'
  require('diffview').setup {
    use_icons = false,
    enhanced_diff_hl = true,
    keymaps = {
      view = {
        { 'n', 'q', diffview_actions.close, { desc = 'Close diffview' } },
        { 'n', '<Esc>', diffview_actions.close, { desc = 'Close diffview' } },
      },
      file_panel = {
        { 'n', 'q', diffview_actions.close, { desc = 'Close diffview' } },
        { 'n', '<Esc>', diffview_actions.close, { desc = 'Close diffview' } },
      },
    },
  }

  -- Useful plugin to show you pending keybinds.
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    -- Delay between pressing a key and opening which-key (milliseconds)
    delay = 500,
    icons = { mappings = vim.g.have_nerd_font },
    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>f', group = '[F]ile' },
      { '<leader>t', group = '[T]oggle' },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  -- [[ Colorscheme ]]
  -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command under that to load whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  vim.o.background = 'dark'
  vim.pack.add { gh 'sainnhe/gruvbox-material' }
  vim.cmd.colorscheme 'gruvbox-material'

  -- Make changed lines visible in both Diffview and inline diffs. Gruvbox's
  -- defaults are intentionally subtle, so use explicit foreground and
  -- background colours here.
  for group, colors in pairs {
    DiffAdd = { fg = '#b8bb26', bg = '#3d4f35' },
    DiffDelete = { fg = '#fb4934', bg = '#4f3030' },
    DiffChange = { fg = '#83a598', bg = '#3b4650' },
    DiffText = { fg = '#ebdbb2', bg = '#5b6b3b', bold = true },
    DiffviewDiffAdd = { fg = '#b8bb26', bg = '#3d4f35' },
    DiffviewDiffDelete = { fg = '#fb4934', bg = '#4f3030' },
    DiffviewDiffAddAsDelete = { fg = '#fb4934', bg = '#4f3030' },
    DiffviewDiffDeleteDim = { fg = '#fb4934', bg = '#4f3030' },
    DiffviewDiffChange = { fg = '#83a598', bg = '#3b4650' },
    DiffviewDiffText = { fg = '#ebdbb2', bg = '#5b6b3b', bold = true },
    InlineDiffAddContext = { fg = '#b8bb26', bg = '#263b27' },
    InlineDiffAddChange = { fg = '#ebdbb2', bg = '#4d7535', bold = true },
    InlineDiffDeleteContext = { fg = '#fb4934', bg = '#3b2525' },
    InlineDiffDeleteChange = { fg = '#ebdbb2', bg = '#733b3b', bold = true },
  } do
    vim.api.nvim_set_hl(0, group, colors)
  end

  vim.api.nvim_set_hl(0, 'StatuslineGitAdd', { fg = '#a9b665' })
  vim.api.nvim_set_hl(0, 'StatuslineGitRemove', { fg = '#ea6962' })
  vim.api.nvim_set_hl(0, 'StatuslineGitFiles', { fg = '#7daea3' })

  -- [[ Hop.nvim ]]
  -- An EasyMotion-like word jump with labels.
  vim.pack.add { gh 'smoka7/hop.nvim' }
  local hop = require 'hop'
  hop.setup {}
  vim.keymap.set({ 'n', 'x', 'o' }, '<leader>w', hop.hint_words, { desc = '[W]ord jump' })

  -- Highlight todo, notes, etc in comments
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  -- [[ mini.nvim ]]
  --  A collection of various small independent plugins/modules
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  -- If a nerd font is available, load the icons module for pretty icons in various plugins.
  if vim.g.have_nerd_font then
    require('mini.icons').setup()
    -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
    MiniIcons.mock_nvim_web_devicons()
  end

  -- Better Around/Inside textobjects
  --
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  require('mini.ai').setup {
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
    mappings = {
      around_next = 'aa',
      inside_next = 'ii',
    },
    n_lines = 500,
  }

  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  -- - sd'   - [S]urround [D]elete [']quotes
  -- - sr)'  - [S]urround [R]eplace [)] [']
  require('mini.surround').setup()

  -- Simple and easy statusline.
  --  You could remove this setup call if you don't like it,
  --  and try some other statusline plugin
  local statusline = require 'mini.statusline'

  -- Keep the statusline focused on the essentials: mode, repository-wide Git
  -- diff, changed-file count, and language. Git commands run asynchronously
  -- and their results are cached so redrawing the statusline stays cheap.
  local changed_file_count
  local changed_file_root
  local changed_file_job
  local overall_added
  local overall_removed
  local overall_diff_root
  local overall_diff_job

  local function refresh_changed_file_count(force)
    local root = vim.fs.root(0, { '.git' })
    if not root then
      changed_file_count = nil
      changed_file_root = nil
      return
    end

    if changed_file_job or (not force and changed_file_root == root and changed_file_count ~= nil) then return end

    changed_file_job = vim.system({ 'git', 'status', '--porcelain=v1' }, { cwd = root, text = true }, function(result)
      local count = 0
      for _ in (result.stdout or ''):gmatch '[^\r\n]+' do
        count = count + 1
      end

      vim.schedule(function()
        changed_file_job = nil
        changed_file_root = root
        changed_file_count = result.code == 0 and count or 0
        vim.cmd.redrawstatus()
      end)
    end)
  end

  local function count_untracked_lines(root, paths)
    local count = 0
    for relative_path in (paths or ''):gmatch '([^%z]+)%z' do
      local file = io.open(vim.fs.joinpath(root, relative_path), 'rb')
      if file then
        local contents = file:read '*a' or ''
        file:close()
        -- Git does not report line deltas for binary files.
        if not contents:find('\0', 1, true) and #contents > 0 then
          count = count + select(2, contents:gsub('\n', ''))
          if contents:sub(-1) ~= '\n' then count = count + 1 end
        end
      end
    end
    return count
  end

  local function refresh_overall_diff(force)
    local root = vim.fs.root(0, { '.git' })
    if not root then
      overall_added = nil
      overall_removed = nil
      overall_diff_root = nil
      return
    end

    if overall_diff_job or (not force and overall_diff_root == root and overall_added ~= nil) then return end

    -- HEAD includes staged and unstaged tracked changes. Untracked files are
    -- counted separately as additions. Both Git commands run asynchronously.
    overall_diff_job = vim.system({ 'git', 'diff', 'HEAD', '--shortstat' }, { cwd = root, text = true }, function(result)
      local stdout = result.stdout or ''
      local added = tonumber(stdout:match '(%d+) insertion') or 0
      local removed = tonumber(stdout:match '(%d+) deletion') or 0

      vim.system({ 'git', 'ls-files', '--others', '--exclude-standard', '-z' }, { cwd = root, text = true }, function(untracked)
        vim.schedule(function()
          overall_diff_job = nil
          overall_diff_root = root
          overall_added = result.code == 0 and added + count_untracked_lines(root, untracked.stdout) or 0
          overall_removed = result.code == 0 and removed or 0
          vim.cmd.redrawstatus()
        end)
      end)
    end)
  end

  local function active_statusline()
    refresh_changed_file_count()
    refresh_overall_diff()

    local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
    local added, removed = overall_added or 0, overall_removed or 0
    local git_info = {}
    if added > 0 then
      table.insert(git_info, { hl = 'StatuslineGitAdd', strings = { '+' .. added } })
    end
    if removed > 0 then
      table.insert(git_info, { hl = 'StatuslineGitRemove', strings = { '-' .. removed } })
    end
    if changed_file_count ~= nil then
      table.insert(git_info, { hl = 'StatuslineGitFiles', strings = { '󰈔 ' .. changed_file_count } })
    end

    local language = vim.bo.filetype
    if language ~= '' and vim.g.have_nerd_font then
      local icon = select(1, MiniIcons.get('filetype', language))
      language = icon .. ' ' .. language
    end

    local groups = { { hl = mode_hl, strings = { mode } } }
    vim.list_extend(groups, git_info)
    table.insert(groups, '%=')
    table.insert(groups, { hl = 'MiniStatuslineFileinfo', strings = { language } })
    return statusline.combine_groups(groups)
  end

  local statusline_git_group = vim.api.nvim_create_augroup('statusline-git', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'FocusGained', 'ShellCmdPost', 'TermLeave' }, {
    group = statusline_git_group,
    callback = function()
      refresh_changed_file_count(true)
      refresh_overall_diff(true)
    end,
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'GitSignsUpdate',
    group = statusline_git_group,
    callback = function()
      refresh_changed_file_count(true)
      refresh_overall_diff(true)
    end,
  })

  statusline.setup {
    use_icons = vim.g.have_nerd_font,
    content = { active = active_statusline },
  }

  -- ... and there is more!
  --  Check out: https://github.com/nvim-mini/mini.nvim
end

-- ============================================================
-- SECTION 5: SEARCH & NAVIGATION
-- Telescope setup, keymaps, LSP picker mappings
-- ============================================================
do
  -- Sidebar file tree.
  vim.pack.add {
    gh 'nvim-tree/nvim-tree.lua',
    gh 'nvim-tree/nvim-web-devicons',
  }
  require('nvim-tree').setup {
    on_attach = function(bufnr)
      local api = require 'nvim-tree.api'
      api.map.on_attach.default(bufnr)
      local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }
      vim.keymap.set('n', '<Esc>', api.tree.close, vim.tbl_extend('force', opts, { desc = 'Close file tree' }))
      vim.keymap.set('n', '/', api.filter.live.start, vim.tbl_extend('force', opts, { desc = 'Filter file tree' }))
    end,
    view = {
      side = 'left',
      width = 32,
      preserve_window_proportions = true,
    },
    renderer = {
      group_empty = true,
      indent_markers = { enable = true },
    },
    update_focused_file = {
      enable = true,
      update_root = false,
    },
    actions = {
      open_file = {
        -- Selecting a file closes the tree and returns to the editor.
        quit_on_open = true,
      },
    },
    git = { enable = true, ignore = true },
    filters = { dotfiles = false },
  }

  -- Make the tree inherit the active colorscheme instead of using its own
  -- opaque background.
  local function sync_nvim_tree_highlights()
    for target, source in pairs {
      NvimTreeNormal = 'Normal',
      NvimTreeNormalNC = 'Normal',
      NvimTreeNormalFloat = 'Normal',
      NvimTreeEndOfBuffer = 'EndOfBuffer',
      NvimTreeWinSeparator = 'WinSeparator',
    } do
      vim.api.nvim_set_hl(0, target, { link = source })
    end
  end
  sync_nvim_tree_highlights()
  vim.api.nvim_create_autocmd('ColorScheme', { callback = sync_nvim_tree_highlights })

  local nvim_tree_api = require 'nvim-tree.api'
  vim.keymap.set('n', '<leader>e', function()
    if nvim_tree_api.tree.is_visible() then
      nvim_tree_api.tree.close()
    else
      -- Open the tree in the current window as a full-screen file chooser.
      nvim_tree_api.tree.open { current_window = true }
    end
  end, { desc = 'Toggle full-screen file tree' })

  -- [[ Fuzzy Finder (files, lsp, etc) ]]
  --
  -- Telescope is a fuzzy finder that comes with a lot of different things that
  -- it can fuzzy find! It's more than just a "file finder", it can search
  -- many different aspects of Neovim, your workspace, LSP, and more!
  --
  -- There are lots of other alternative pickers (like snacks.picker, or fzf-lua)
  -- so feel free to experiment and see what you like!
  --
  -- The easiest way to use Telescope, is to start by doing something like:
  --  :Telescope help_tags
  --
  -- After running this command, a window will open up and you're able to
  -- type in the prompt window. You'll see a list of `help_tags` options and
  -- a corresponding preview of the help.
  --
  -- Two important keymaps to use while in Telescope are:
  --  - Insert mode: <c-/>
  --  - Normal mode: ?
  --
  -- This opens a window that shows you all of the keymaps for the current
  -- Telescope picker. This is really useful to discover what Telescope can
  -- do as well as how to actually do it!

  ---@type (string|vim.pack.Spec)[]
  local telescope_plugins = {
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
  }
  if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

  -- NOTE: You can install multiple plugins at once
  vim.pack.add(telescope_plugins)

  -- See `:help telescope` and `:help telescope.setup()`
  require('telescope').setup {
    defaults = {
      -- Put the prompt first and sort the best matches from top to bottom.
      sorting_strategy = 'ascending',
      layout_strategy = 'vertical',
      layout_config = {
        prompt_position = 'top',
        mirror = true,
      },
      -- Keep the filename prominent while retaining its directory context.
      path_display = { 'filename_first' },
    },
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
  }

  -- Enable Telescope extensions if they are installed
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')

  -- See `:help telescope.builtin`
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  local file_picker_layout = {
    layout_strategy = 'vertical',
    layout_config = {
      prompt_position = 'top',
      mirror = true,
      width = 0.7,
      height = 0.85,
      preview_height = 0.35,
    },
  }

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local telescope_config = require('telescope.config').values
  local make_entry = require 'telescope.make_entry'

  local function recent_files()
    local current_buffer = vim.api.nvim_get_current_buf()
    local current_file = vim.api.nvim_buf_get_name(current_buffer)
    local results = {}
    local seen = {}

    local function add_file(file)
      if file == '' or file == current_file or seen[file] then return end
      local stat = vim.uv.fs_stat(file)
      if stat and stat.type == 'file' then
        seen[file] = true
        results[#results + 1] = file
      end
    end

    -- Include files opened during this session, followed by ShaDa history.
    local buffers = vim.fn.getbufinfo { buflisted = 1 }
    table.sort(buffers, function(a, b) return (a.lastused or 0) > (b.lastused or 0) end)
    for _, buffer in ipairs(buffers) do
      add_file(buffer.name)
    end
    for _, file in ipairs(vim.v.oldfiles) do
      add_file(file)
    end

    return results
  end

  -- Start with recent files, then switch to the normal rg-backed file list as
  -- soon as the prompt is non-empty. This keeps <leader>ff useful for both
  -- quick access and searching the entire workspace.
  vim.keymap.set('n', '<leader>ff', function()
    local opts = vim.tbl_extend('force', file_picker_layout, {
      prompt_title = 'Recent Files',
      __locations_input = true,
    })
    local recent = recent_files()
    local function all_files_command()
      if vim.fn.executable 'rg' == 1 then return { 'rg', '--files', '--color', 'never' } end
      if vim.fn.executable 'fd' == 1 then return { 'fd', '--type', 'f', '--color', 'never' } end
      if vim.fn.executable 'fdfind' == 1 then return { 'fdfind', '--type', 'f', '--color', 'never' } end
      return { 'find', '.', '-type', 'f', '-not', '-path', '*/.*' }
    end

    local entry_maker = make_entry.gen_from_file(opts)
    local recent_finder = finders.new_table {
      results = recent,
      entry_maker = entry_maker,
    }
    -- Use Telescope's one-shot finder for the full file list. It caches the
    -- results, just like builtin.find_files, so typing does not restart rg.
    local all_files_finder = finders.new_oneshot_job(all_files_command(), {
      cwd = opts.cwd,
      entry_maker = entry_maker,
    })
    local showing_all_files = false

    pickers
      .new(opts, {
        finder = recent_finder,
        on_input_filter_cb = function(prompt)
          local should_show_all_files = prompt ~= ''
          if should_show_all_files == showing_all_files then return end
          showing_all_files = should_show_all_files
          return { updated_finder = should_show_all_files and all_files_finder or recent_finder }
        end,
        previewer = telescope_config.grep_previewer(opts),
        sorter = telescope_config.file_sorter(opts),
      })
      :find()
  end, { desc = '[F]ind recent files or search all files' })

  vim.keymap.set('n', '<leader>fd', function()
    local filename = vim.api.nvim_buf_get_name(0)
    local cwd = filename ~= '' and vim.fs.dirname(vim.fs.normalize(filename)) or vim.fn.getcwd()
    builtin.find_files(vim.tbl_extend('force', file_picker_layout, {
      cwd = cwd,
      prompt_title = 'Files in ' .. cwd,
    }))
  end, { desc = '[F]ind files in current [D]irectory' })

  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  for group, fg in pairs {
    TelescopeGitModified = '#d79921',
    TelescopeGitCreated = '#b8bb26',
    TelescopeGitDeleted = '#fb4934',
    TelescopeGitAdded = '#b8bb26',
    TelescopeGitRemoved = '#fb4934',
  } do
    vim.api.nvim_set_hl(0, group, { fg = fg, bold = true })
  end
  -- Keep the selected row's background without masking the status colours.
  vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = '#3d4f35' })

  vim.keymap.set('n', '<leader>g', function()
    local cwd = vim.fs.root(0, { '.git' }) or vim.fn.getcwd()
    local picker_opts = {
      cwd = cwd,
      layout_strategy = 'vertical',
      layout_config = {
        prompt_position = 'top',
        mirror = true,
        width = 0.9,
        height = 0.8,
        preview_height = 0.4,
      },
    }

    -- Keep the status compact while retaining the aggregate diff and preview.
    vim.system({ 'git', 'diff', '--numstat', 'HEAD', '--', '.' }, { cwd = cwd, text = true }, function(result)
      local diff_stats = {}
      if result.code == 0 then
        for line in result.stdout:gmatch '[^\r\n]+' do
          local added, removed, path = line:match '^(%S+)\t(%S+)\t(.+)$'
          if path then diff_stats[path] = { added = added, removed = removed } end
        end
      end

      vim.schedule(function()
        local make_entry = require 'telescope.make_entry'
        local entry_display = require 'telescope.pickers.entry_display'
        local utils = require 'telescope.utils'
        local default_entry_maker = make_entry.gen_from_git_status(picker_opts)
        local displayer = entry_display.create {
          separator = ' ',
          items = {
            { width = 1 },
            { width = 14 },
            { remaining = true },
          },
        }
        local status_chars = {
          A = 'C',
          C = 'C',
          D = 'D',
          M = 'M',
          R = 'M',
          U = 'M',
          ['?'] = 'C',
        }
        local status_highlights = {
          M = 'TelescopeGitModified',
          C = 'TelescopeGitCreated',
          D = 'TelescopeGitDeleted',
        }

        picker_opts.entry_maker = function(raw_entry)
          local entry = default_entry_maker(raw_entry)
          if not entry then return nil end

          local x = entry.status:sub(1, 1)
          local y = entry.status:sub(-1)
          local primary = x ~= ' ' and x or y
          local status = status_chars[primary] or 'M'
          local stat = diff_stats[entry.value]
          local delta = ''
          local delta_hl
          if stat then
            if stat.added == '-' or stat.removed == '-' then
              delta = 'binary'
            else
              delta = '+' .. stat.added .. ' -' .. stat.removed
              delta_hl = function()
                local separator = delta:find ' '
                return {
                  { { 0, separator - 1 }, 'TelescopeGitAdded' },
                  { { separator, #delta }, 'TelescopeGitRemoved' },
                }
              end
            end
          end
          local display_path, path_style = utils.transform_path(picker_opts, entry.path)

          entry.display = function()
            return displayer {
              { status, status_highlights[status] },
              { delta, delta_hl },
              { display_path, function() return path_style end },
            }
          end
          return entry
        end

        -- Telescope's stock Git preview always shells out to `git diff`.
        -- Replace it just while this picker is being built so its preview
        -- uses difftastic when available. A terminal preview is used so
        -- Difftastic's ANSI colours are rendered instead of shown as text.
        local telescope_previewers = require 'telescope.previewers'
        local original_git_file_diff = telescope_previewers.git_file_diff
        local difftastic_available = vim.fn.executable 'difft' == 1
        telescope_previewers.git_file_diff = {
          new = function(opts)
            return telescope_previewers.new_termopen_previewer {
              title = difftastic_available and 'Git File Diff (difftastic)' or 'Git File Diff',
              env = difftastic_available and {
                DFT_COLOR = 'always',
                DFT_DISPLAY = 'side-by-side',
                DFT_BACKGROUND = 'dark',
              } or nil,
              get_command = function(entry)
                if entry.status == '??' then
                  if not difftastic_available then return { 'cat', '--', entry.path } end
                  return { 'difft', '--display=side-by-side', '--color=always', '/dev/null', entry.path }
                end

                local command = { 'git', '--no-pager' }
                if difftastic_available then
                  vim.list_extend(command, { '-c', 'diff.external=difft' })
                else
                  vim.list_extend(command, { '-c', 'color.ui=always' })
                end
                vim.list_extend(command, { 'diff', '--color=always', 'HEAD', '--', entry.value })
                return command
              end,
              cwd = opts.cwd,
            }
          end,
        }

        local ok, err = pcall(builtin.git_status, picker_opts)
        telescope_previewers.git_file_diff = original_git_file_diff
        if not ok then error(err) end
      end)
    end)
  end, { desc = '[G]it status' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind existing [B]uffers' })

  -- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
  -- If you later switch picker plugins, this is where to update these mappings.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf

      -- Find references for the word under your cursor.
      vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

      -- Jump to the implementation of the word under your cursor.
      -- Useful when your language has ways of declaring types without an actual implementation.
      vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

      -- Jump to the definition of the word under your cursor.
      -- This is where a variable was first declared, or where a function is defined, etc.
      -- To jump back, press <C-t>.
      vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

      -- Fuzzy find all the symbols in your current document.
      -- Symbols are things like variables, functions, types, etc.
      vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
      vim.keymap.set('n', '<leader>s', builtin.lsp_document_symbols, { buffer = buf, desc = '[S]earch document [S]ymbols' })

      -- Fuzzy find all the symbols in your current workspace.
      -- Similar to document symbols, except searches over your entire project.
      vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

      -- Jump to the type of the word under your cursor.
      -- Useful when you're not sure what type a variable is and you want to see
      -- the definition of its *type*, not where it was *defined*.
      vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    end,
  })

  -- Override default behavior and theme when searching
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  -- It's also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set(
    'n',
    '<leader>s/',
    function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end,
    { desc = '[S]earch [/] in Open Files' }
  )

  -- Shortcut for searching your Neovim configuration files
  vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true } end, { desc = '[S]earch [N]eovim files' })
end

-- Find the nearest project configuration above a buffer. Formatting and
-- linting use these helpers to opt into project tooling rather than imposing a
-- global formatter on every file of a given language.
local function project_file(bufnr, names)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local start = filename ~= '' and vim.fs.dirname(filename) or vim.uv.cwd()
  return vim.fs.find(names, { path = start, upward = true, type = 'file' })[1]
end

local function project_file_contains(bufnr, name, pattern)
  local path = project_file(bufnr, { name })
  if not path then return false end
  local file = io.open(path, 'r')
  if not file then return false end
  local content = file:read '*a'
  file:close()
  return content:find(pattern) ~= nil
end

-- ============================================================
-- SECTION 6: LSP
-- LSP keymaps, server configuration, Mason tools installations
-- ============================================================
do
  -- [[ LSP Configuration ]]
  -- Brief aside: **What is LSP?**
  --
  -- LSP is an initialism you've probably heard, but might not understand what it is.
  --
  -- LSP stands for Language Server Protocol. It's a protocol that helps editors
  -- and language tooling communicate in a standardized fashion.
  --
  -- In general, you have a "server" which is some tool built to understand a particular
  -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
  -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
  -- processes that communicate with some "client" - in this case, Neovim!
  --
  -- LSP provides Neovim with features like:
  --  - Go to definition
  --  - Find references
  --  - Autocompletion
  --  - Symbol Search
  --  - and more!
  --
  -- Thus, Language Servers are external tools that must be installed separately from
  -- Neovim. This is where `mason` and related plugins come into play.
  --
  -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  -- and elegantly composed help section, `:help lsp-vs-treesitter`

  -- Useful status updates for LSP.
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  --  This function gets run when an LSP attaches to a particular buffer.
  --    That is to say, every time a new file is opened that is associated with
  --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --    function will be executed to configure the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- Rename the variable under your cursor.
      --  Most Language Servers support renaming across files, etc.
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      map('gp', function() vim.diagnostic.jump { count = 1 } end, '[G]oto next diagnostic')
      map('gP', function() vim.diagnostic.jump { count = -1 } end, '[G]oto previous diagnostic')

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- The following code creates a keymap to toggle inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>h', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, 'Toggle Inlay [H]ints')
      end
    end,
  })

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --  See `:help lsp-config` for information about keys and how to configure
  local function project_lsp_command(command, args)
    return function(dispatchers, config)
      local executable = command
      if config.root_dir then
        local project_executable = vim.fs.joinpath(config.root_dir, '.venv', 'bin', command)
        if vim.fn.executable(project_executable) == 1 then executable = project_executable end
      end
      return vim.lsp.rpc.start(vim.list_extend({ executable }, args), dispatchers)
    end
  end

  local function project_node_lsp_command(command, args)
    return function(dispatchers, config)
      local executable = command
      if config.root_dir then
        local node_modules = vim.fs.find('node_modules', {
          path = config.root_dir,
          upward = true,
          type = 'directory',
          limit = math.huge,
        })
        for _, directory in ipairs(node_modules) do
          local project_executable = vim.fs.joinpath(directory, '.bin', command)
          if vim.fn.executable(project_executable) == 1 then
            executable = project_executable
            break
          end
        end
      end
      return vim.lsp.rpc.start(vim.list_extend({ executable }, args), dispatchers)
    end
  end

  -- MDX analyzer's TypeScript integration still requires tsserverlibrary.js,
  -- which TypeScript 7 no longer ships. Prefer the nearest compatible project
  -- SDK, including versions stored by pnpm.
  local function typescript_sdk_path(root_dir)
    local directory = root_dir or vim.uv.cwd()
    while directory do
      local candidates = { vim.fs.joinpath(directory, 'node_modules', 'typescript', 'lib') }
      local pnpm_directory = vim.fs.joinpath(directory, 'node_modules', '.pnpm')
      if vim.uv.fs_stat(pnpm_directory) then
        local pnpm_typescript = {}
        for name, kind in vim.fs.dir(pnpm_directory) do
          if kind == 'directory' and name:match '^typescript@' then table.insert(pnpm_typescript, name) end
        end
        table.sort(pnpm_typescript, function(left, right) return left > right end)
        for _, name in ipairs(pnpm_typescript) do
          table.insert(candidates, vim.fs.joinpath(pnpm_directory, name, 'node_modules', 'typescript', 'lib'))
        end
      end

      for _, candidate in ipairs(candidates) do
        if vim.uv.fs_stat(vim.fs.joinpath(candidate, 'tsserverlibrary.js')) then return candidate end
      end

      local parent = vim.fs.dirname(directory)
      if parent == directory then break end
      directory = parent
    end
  end

  -- The current Mason mdx-analyzer release has one stale default import from
  -- vscode-uri. Load a tiny Node hook that rewrites that generated import so
  -- the server can start without modifying Mason's managed files.
  local mdx_language_server_loader = vim.fs.joinpath(vim.fn.stdpath 'config', 'scripts', 'mdx-language-server-loader.mjs')
  local function mdx_language_server_command(dispatchers)
    local executable = vim.fn.exepath 'mdx-language-server'
    if executable == '' then executable = 'mdx-language-server' else executable = vim.fn.resolve(executable) end
    return vim.lsp.rpc.start({ 'node', '--experimental-loader=' .. mdx_language_server_loader, executable, '--stdio' }, dispatchers)
  end

  -- These servers are executables owned by each Python project. Keep them out
  -- of Mason's installation list and prefer the nearest .venv version.
  ---@type table<string, vim.lsp.Config>
  local project_servers = {
    ty = { cmd = project_lsp_command('ty', { 'server' }) },
    ruff = {
      cmd = project_lsp_command('ruff', { 'server' }),
      -- Let ty own Python hover/type information while Ruff provides linting,
      -- code actions, and formatting without duplicate hover responses.
      on_attach = function(client) client.server_capabilities.hoverProvider = false end,
      root_dir = function(bufnr, on_dir)
        local config = project_file(bufnr, { 'ruff.toml', '.ruff.toml' })
        if not config and project_file_contains(bufnr, 'pyproject.toml', '%[tool%.ruff') then
          config = project_file(bufnr, { 'pyproject.toml' })
        end
        if config then on_dir(vim.fs.dirname(config)) end
      end,
    },
  }

  ---@type table<string, vim.lsp.Config>
  local servers = {
    -- clangd = {},
    -- gopls = {},
    rust_analyzer = {},
    taplo = {}, -- TOML language server
    html = {
      -- Django templates still contain ordinary HTML that the HTML language
      -- server can understand. Keep the template filetype so other tooling
      -- can distinguish it from standalone HTML files.
      filetypes = { 'html', 'htmldjango' },
      init_options = {
        provideFormatter = true,
        embeddedLanguages = {
          css = true,
          javascript = true,
        },
      },
    },
    cssls = {},
    mdx_analyzer = {
      cmd = mdx_language_server_command,
      before_init = function(_, config)
        local sdk = typescript_sdk_path(config.root_dir)
        if not sdk then return end
        config.init_options = config.init_options or {}
        config.init_options.typescript = config.init_options.typescript or {}
        config.init_options.typescript.enabled = true
        config.init_options.typescript.tsdk = sdk
      end,
    },
    omnisharp = {}, -- C#
    intelephense = {}, -- PHP
    --
    -- Some languages (like typescript) have entire language plugins that can be useful:
    --    https://github.com/pmizio/typescript-tools.nvim
    --
    -- JavaScript and TypeScript use the native TypeScript 7 Go LSP below.

    stylua = {}, -- Used to format Lua code

    -- Special Lua Config, as recommended by neovim help docs
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end

        local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
        client.config.settings.Lua = vim.tbl_deep_extend('force', current_settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
            --  See https://github.com/neovim/nvim-lspconfig/issues/3189
            library = vim.api.nvim_get_runtime_file('', true),
          },
        })
      end,
      ---@type lspconfig.settings.lua_ls
      settings = {
        Lua = {
          format = { enable = false }, -- Disable formatting (formatting is done by stylua)
        },
      },
    },
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  -- Automatically install LSPs and related tools to stdpath for Neovim
  require('mason').setup {}

  -- Translates between nvim-lspconfig server names and mason.nvim package names (e.g. lua_ls <-> lua-language-server)
  require('mason-lspconfig').setup {
    automatic_enable = false, -- Change this to true if you want to automatically enable servers that are installed manually (e.g. via :Mason / :MasonInstall)
  }

  -- Ensure the servers and tools above are installed
  --
  -- To check the current status of installed tools and/or manually install
  -- other tools, you can run
  --    :Mason
  --
  -- You can press `g?` for help in this menu.
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    -- Protocol/fix adapters load each project's own ESLint installation; the
    -- actual linter version remains project-owned.
    'eslint-lsp',
    'eslint_d',
  })

  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
  for name, server in pairs(project_servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end

  -- Project-configured web linters attach only when their own config exists.
  vim.lsp.config('biome', { cmd = project_node_lsp_command('biome', { 'lsp-proxy' }) })
  vim.lsp.config('oxlint', { cmd = project_node_lsp_command('oxlint', { '--lsp' }) })
  vim.lsp.enable('biome')
  vim.lsp.enable('eslint')
  vim.lsp.enable('oxlint')

  -- TypeScript 7's native Go-based language server. Prefer the repository's
  -- TypeScript version (including monorepo-root node_modules) over PATH.
  vim.lsp.config('tsgo', {
    cmd = project_node_lsp_command('tsc', { '--lsp', '--stdio' }),
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  })
  vim.lsp.enable('tsgo')
end

-- ============================================================
-- SECTION 7: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
do
  -- [[ Formatting ]]
  vim.pack.add { gh 'stevearc/conform.nvim' }
  local conform_util = require 'conform.util'
  local function python_command(command) return conform_util.find_executable({ '.venv/bin/' .. command }, command) end

  local function python_formatters(bufnr)
    if project_file(bufnr, { 'ruff.toml', '.ruff.toml' }) or project_file_contains(bufnr, 'pyproject.toml', '%[tool%.ruff') then
      return { 'ruff_fix', 'ruff_format' }
    end

    local formatters = {}
    if project_file_contains(bufnr, 'pyproject.toml', '%[tool%.isort%]') then table.insert(formatters, 'isort') end
    if project_file_contains(bufnr, 'pyproject.toml', '%[tool%.black%]') then table.insert(formatters, 'black') end
    return formatters
  end

  local eslint_configs = {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.json',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    'eslint.config.js',
    'eslint.config.cjs',
    'eslint.config.mjs',
    'eslint.config.ts',
    'eslint.config.cts',
    'eslint.config.mts',
  }
  local prettier_configs = {
    '.prettierrc',
    '.prettierrc.js',
    '.prettierrc.cjs',
    '.prettierrc.json',
    '.prettierrc.json5',
    '.prettierrc.mjs',
    '.prettierrc.toml',
    '.prettierrc.yaml',
    '.prettierrc.yml',
    'prettier.config.js',
    'prettier.config.cjs',
    'prettier.config.mjs',
  }
  local biome_configs = { 'biome.json', 'biome.jsonc', '.biome.json', '.biome.jsonc' }
  local oxfmt_configs = { '.oxfmtrc.json', '.oxfmtrc.jsonc', 'oxfmt.config.ts' }
  local oxlint_configs = { '.oxlintrc.json', '.oxlintrc.jsonc', 'oxlint.config.ts' }

  local function uses_prettier(bufnr)
    return project_file(bufnr, prettier_configs) or project_file_contains(bufnr, 'package.json', '"prettier"')
  end

  local function web_code_formatters(bufnr)
    local uses_oxfmt = project_file(bufnr, oxfmt_configs)
    local uses_oxlint = project_file(bufnr, oxlint_configs)
    if uses_oxfmt or uses_oxlint then
      local formatters = {}
      if uses_oxlint then table.insert(formatters, 'oxlint') end
      if uses_oxfmt then table.insert(formatters, 'oxfmt') end
      return formatters
    end
    if project_file(bufnr, biome_configs) then return { 'biome-check' } end

    local formatters = {}
    if project_file(bufnr, eslint_configs) or project_file_contains(bufnr, 'package.json', '"eslintConfig"') then
      table.insert(formatters, 'eslint_d')
    end
    if uses_prettier(bufnr) then table.insert(formatters, 'prettier') end
    return formatters
  end

  local function web_document_formatters(bufnr)
    if project_file(bufnr, oxfmt_configs) then return { 'oxfmt' } end
    if project_file(bufnr, biome_configs) then return { 'biome-check' } end
    return uses_prettier(bufnr) and { 'prettier' } or {}
  end

  local function configured(bufnr, markers, formatter)
    return project_file(bufnr, markers) and { formatter } or {}
  end

  require('conform').setup {
    notify_on_error = true,
    notify_no_formatters = false,
    -- Format asynchronously after every ordinary file write. Explicit project
    -- formatters win; an attached LSP is the fallback. The formatted buffer is
    -- written back by conform once formatting completes.
    format_after_save = function(bufnr)
      if vim.bo[bufnr].buftype ~= '' or not vim.bo[bufnr].modifiable then return nil end
      return { timeout_ms = 3000, lsp_format = 'fallback' }
    end,
    default_format_opts = {
      lsp_format = 'fallback',
      timeout_ms = 3000,
    },
    formatters = {
      -- Prefer the tool version locked by uv/pip in the nearest project, with
      -- Mason/PATH as a fallback for projects that configure it externally.
      ruff_fix = { command = python_command 'ruff' },
      ruff_format = { command = python_command 'ruff' },
      isort = { command = python_command 'isort' },
      black = { command = python_command 'black' },
    },
    formatters_by_ft = {
      python = python_formatters,
      javascript = web_code_formatters,
      javascriptreact = web_code_formatters,
      typescript = web_code_formatters,
      typescriptreact = web_code_formatters,
      json = web_document_formatters,
      jsonc = web_document_formatters,
      css = web_document_formatters,
      scss = web_document_formatters,
      less = web_document_formatters,
      html = web_document_formatters,
      markdown = web_document_formatters,
      mdx = web_document_formatters,
      yaml = web_document_formatters,
      lua = function(bufnr) return configured(bufnr, { '.stylua.toml', 'stylua.toml' }, 'stylua') end,
      rust = function(bufnr) return configured(bufnr, { 'Cargo.toml' }, 'rustfmt') end,
      c = function(bufnr) return configured(bufnr, { '.clang-format', '_clang-format' }, 'clang_format') end,
      cpp = function(bufnr) return configured(bufnr, { '.clang-format', '_clang-format' }, 'clang_format') end,
      cs = function(bufnr) return configured(bufnr, { '.csharpierrc', 'dotnet-tools.json' }, 'csharpier') end,
      php = function(bufnr)
        return configured(bufnr, { '.php-cs-fixer.php', '.php-cs-fixer.dist.php' }, 'php_cs_fixer')
      end,
      sh = function(bufnr) return configured(bufnr, { '.editorconfig', '.shfmt' }, 'shfmt') end,
      toml = function(bufnr) return configured(bufnr, { 'taplo.toml', '.taplo.toml' }, 'taplo') end,
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>F', function()
    require('conform').format { async = true, lsp_format = 'fallback' }
  end, { desc = '[F]ix and format buffer' })
end

-- ============================================================
-- SECTION 8: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
do
  -- [[ Snippet Engine ]]

  -- NOTE: You can also specify plugin using a version range for its git tag.
  --  See `:help vim.version.range()` for more info
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  -- `friendly-snippets` contains a variety of premade snippets.
  --    See the README about individual language/framework/plugin snippets:
  --    https://github.com/rafamadriz/friendly-snippets
  --
  -- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
  -- require('luasnip.loaders.from_vscode').lazy_load()

  -- [[ Autocomplete Engine ]]
  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See `:help blink-cmp-config-keymap` for defining your own keymap
      preset = 'enter',

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    completion = {
      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },

    snippets = { preset = 'luasnip' },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See `:help blink-cmp-config-fuzzy` for more information
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  }
end

-- ============================================================
-- SECTION 9: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
do
  -- [[ Configure Treesitter ]]
  --  Used to highlight, edit, and navigate code
  --
  --  See `:help nvim-treesitter-intro`

  -- NOTE: You can also specify a branch or a specific commit
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  -- Keep the current function/class context visible while scrolling.
  vim.pack.add { gh 'nvim-treesitter/nvim-treesitter-context' }
  require('treesitter-context').setup { max_lines = 3 }

  -- Ensure basic parsers are installed
  local parsers = { 'bash', 'c', 'css', 'diff', 'html', 'javascript', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'rust', 'toml', 'vim', 'vimdoc', 'yaml' }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Enable treesitter based folds
    -- For more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- Check if treesitter indentation is available for this language, and if so enable it
    -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- Enable treesitter based indentation
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  -- There is no separate HTML parser for Django templates. Use the HTML
  -- parser for the HTML portions while preserving the `htmldjango` filetype.
  vim.treesitter.language.register('html', 'htmldjango')

  -- MDX has no dedicated Tree-sitter parser. mdx.nvim injects TypeScript/TSX
  -- into imports, exports, and JSX while retaining Markdown for prose/fences.
  vim.pack.add { gh 'davidmh/mdx.nvim' }

  -- markdown_inline interprets some JavaScript module paths as GFM deletion.
  -- Remove that text attribute in MDX windows without masking TSX colours.
  local mdx_highlight_namespace = vim.api.nvim_create_namespace('mdx-highlights')
  vim.api.nvim_set_hl(mdx_highlight_namespace, '@markup.strikethrough', { strikethrough = false })
  local function set_mdx_highlight_namespace(buf)
    local namespace = vim.bo[buf].filetype == 'mdx' and mdx_highlight_namespace or 0
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do vim.api.nvim_win_set_hl_ns(win, namespace) end
  end
  vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
    group = vim.api.nvim_create_augroup('mdx-highlights', { clear = true }),
    callback = function(args) set_mdx_highlight_namespace(args.buf) end,
  })

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match
      set_mdx_highlight_namespace(buf)

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })

  -- LSP support for CSS/HTML embedded in TypeScript templates.
  vim.pack.add { gh 'jmbuhr/otter.nvim' }
  local otter = require 'otter'
  otter.setup {
    buffers = {
      -- Ignore standalone Lit interpolations in extracted CSS.
      ignore_pattern = { css = '^%s*%${.*}$' },
    },
  }
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'htmldjango' },
    callback = function(args)
      if args.match == 'htmldjango' then
        -- Extract <script> and <style> blocks so JavaScript/CSS language
        -- servers can operate on them through Otter.
        otter.activate({ 'javascript', 'css' })
      else
        otter.activate({ 'css', 'html' })
      end
    end,
  })
end

-- ============================================================
-- SECTION 10: OPTIONAL EXAMPLES / NEXT STEPS
-- kickstart.plugins.* examples
-- ============================================================
do
  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug'
  -- require 'kickstart.plugins.indent_line'
  -- require 'kickstart.plugins.lint'
  -- require 'kickstart.plugins.autopairs'
  -- require 'kickstart.plugins.neo-tree'
  -- require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

  -- NOTE: You can add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- require 'custom.plugins'
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
