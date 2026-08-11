# Sam's Neovim configuration

This is a personal fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
It keeps Kickstart's single-file, `vim.pack`-based setup, but adds a workflow
focused on Git, LSP diagnostics, web templates, code navigation, and a
keyboard-driven file tree.

The main configuration is [`init.lua`](init.lua). The other custom files are:

- [`after/queries/typescript/injections.scm`](after/queries/typescript/injections.scm) — Tree-sitter injections for Lit `css` and `html` tagged templates.
- [`nvim-pack-lock.json`](nvim-pack-lock.json) — tracked plugin revisions for reproducible installs.

## Installation

### Requirements

Use a current stable or nightly Neovim. In addition to Neovim, the normal
Kickstart requirements apply:

- `git`, `make`, `unzip`, and a C compiler
- `ripgrep`, `fd`, and the Tree-sitter CLI
- `difftastic` (`difft`), for structural Git previews in `<leader>g`
- An OS clipboard provider
- A selected [Nerd Font](https://www.nerdfonts.com/) (this configuration enables Nerd Font icons)
- `npm`/TypeScript with a `tsc` executable, for the native TypeScript LSP

Mason installs the configured language servers into Neovim's data directory.
Language-specific runtimes and tools may still be needed separately.

### Install

Clone this repository into Neovim's configuration directory:

```sh
git clone git@github.com:samwho/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

Then start Neovim:

```sh
nvim
```

Plugins are installed by Neovim's built-in `vim.pack`. Useful commands are:

```vim
:checkhealth
:Mason
:lua vim.pack.update(nil, { offline = true })
:lua vim.pack.update()
```

The lock file is intentionally committed. If Neovim asks to apply plugin
updates, `:write` applies them and `:quit` cancels them.

## Core preferences

These differ from the Kickstart defaults:

- The global leader is `,`; the local leader remains `<Space>`.
- Nerd Font support is enabled.
- `80` is shown as a `colorcolumn` guide.
- The sign column is always reserved, and diagnostics use solid bullet signs.
- The clipboard uses `unnamedplus`, undo history persists between sessions, and
  the usual Kickstart search, split, mouse, cursorline, scroll, whitespace,
  and confirmation settings remain enabled.

## Keymap reference

The most-used mappings are below. `<leader>` means `,`.

### Navigation and files

| Mapping | Action |
| --- | --- |
| `<leader>e` | Toggle the full-screen `nvim-tree` file chooser |
| `<leader>ff` | Show recent files; typing searches all files with Telescope |
| `<leader>fd` | Find files in the current file's directory |
| `<leader>sf` | Telescope file search |
| `<leader>fb` | Find an existing buffer |
| `<leader>sn` | Search Neovim configuration files |
| `<leader>/` | Fuzzy-search the current buffer |
| `<leader>w` | Hop to a labelled word |
| `<leader>o` | Toggle the Aerial code outline (opens focused; selecting a symbol closes it) |
| `<C-h/j/k/l>` | Move to the left/down/up/right split |
| `H/J/K/L` | Faster split navigation in the same directions |
| `j/k` | Move by display line (`gj/gk`) |
| `<Esc>` in normal mode | Clear search highlighting |
| `<Esc><Esc>` in terminal mode | Leave terminal mode |

Inside `nvim-tree`, `<Esc>` closes the tree, `/` starts live filtering, and
opening a file closes the tree. Dotfiles are shown; Git-ignored files remain
filtered.

### Search and LSP

| Mapping | Action |
| --- | --- |
| `gh` | Show the diagnostic at the cursor, or a focused, scrollable LSP hover when there is no error/warning |
| `gl` | Show the complete diagnostic at the cursor |
| `<leader>q` | Put diagnostics in the location list |
| `gp` / `gP` | Next / previous diagnostic |
| `gd` | Go to definition |
| `grr` | Find references |
| `gri` | Go to implementation |
| `grd` | Telescope definitions |
| `grt` | Go to type definition |
| `gO` | Telescope document symbols |
| `gW` | Telescope workspace symbols |
| `<leader>s` | Telescope document symbols when an LSP is attached |
| `<leader>h` | Toggle LSP inlay hints when supported |
| `<leader>F` | Format the buffer asynchronously |
| `<leader>y` | Copy `relative/file:line` (normal) or `relative/file: start-end` (visual) to the system clipboard |

The `<leader>y` mapping is intended for making file/line references for Pi.
Unnamed buffers are labelled `[No Name]`; it produces no notification.

Other Telescope mappings include `<leader>sh` (help), `<leader>sk` (keymaps),
`<leader>ss` (Telescope pickers), `<leader>sw` (word), `<leader>sg` (live grep),
`<leader>sd` (diagnostics), `<leader>sr` (resume), `<leader>s.` (recent files),
`<leader>sc` (commands), and `<leader>s/` (grep open files). `<leader>ff` starts with recent files, then searches all files once you type;
`<leader>fd` searches the current file's directory.

### Git

| Mapping | Action |
| --- | --- |
| `<leader>g` | Open the Telescope Git status overlay; Enter opens the selected file |
| `<leader>d` | Toggle character-level inline diff highlighting |
| `gc` / `gC` | Next / previous Git hunk |
| `<leader>o` | Toggle the code outline (also useful while reviewing code) |

Git changes are shown with custom line signs and explicit Gruvbox diff colours.
`Satellite` adds a scrollbar containing diagnostics, search, marks, and Git
hunks. `Diffview` is configured for side-by-side review, without icons, and can
be opened with its normal commands such as `:DiffviewOpen`.

The Git status overlay is provided by Telescope. It shows staged/worktree status,
added and removed line counts, and a difftastic structural diff preview when
`difft` is installed; Enter opens the selected file.

## Diagnostics and hover documentation

Diagnostics use `tiny-inline-diagnostic.nvim` with the minimal, transparent
preset. Messages wrap at 30 columns, multiline messages are always shown, and
source/code labels are hidden. Neovim's competing virtual text and virtual
lines renderers are disabled. Diagnostic jumps automatically open a rounded,
unfocused float.

`gh` chooses an error or warning under the cursor before falling back to LSP
hover. Hover windows are rounded, titled `Hover`, wrapped, focused on open,
and limited to 80×15. They can be scrolled with normal movement keys, and
Escape closes a hover. Inline `data:image/...` Markdown
images are removed before hover content is rendered, preventing very large
embedded images from taking over the preview.

## Differences from Kickstart's defaults

The important workflow changes are:

- Tokyo Night is replaced by Gruvbox Material.
- Kickstart's space leader becomes `,`, leaving `<Space>` as the local leader.
- The default file finder is moved from `<leader>f` to `<leader>ff`; buffers use
  `<leader>fb`, and formatting uses uppercase `<leader>F`.
- Blink completion uses the `enter` preset rather than the default preset.
- Built-in virtual diagnostic text is replaced by wrapped inline diagnostics.
- Telescope's Git status picker is the active Git UI.

In addition to Kickstart's plugins, this configuration adds or uses:

- **gruvbox-material** instead of Tokyo Night, with a dark background.
- **nvim-tree** for the file tree, with matching normal-window colours,
  grouped empty directories, indent markers, Git status, and focused-file
  updates without changing the project root.
- **hop.nvim** for labelled word jumps.
- **inlinediff-nvim** for character-level diffs.
- **satellite.nvim** for the decorated scrollbar.
- **aerial.nvim** for Tree-sitter/LSP/Markdown symbols, placed at the left edge
  and sized to its contents. Its local navigation mappings are removed so the
  global split mappings continue to work.
- **dropbar.nvim** for symbol breadcrumbs in the winbar.
- **diffview.nvim** for side-by-side diffs and file history.
- **tiny-inline-diagnostic.nvim** for wrapped inline diagnostics.
- **nvim-treesitter-context** to keep up to three lines of function/class
  context visible while scrolling.
- **otter.nvim** for language-server support inside embedded web languages.

`mini.icons` remains enabled through Kickstart's `mini.nvim` setup, and the
Nerd Font is used in the statusline, Telescope, and plugin UIs.

The statusline is replaced with a compact custom layout containing:

- current mode
- added and removed lines across tracked changes and untracked files
- the number of changed files in the repository, refreshed asynchronously
- the current filetype and its icon

It deliberately omits the default cursor line/column display.

## LSP, completion, and formatting

Mason installs language-server infrastructure and adapters, but project-owned
tools are deliberately resolved from `.venv/bin` or `node_modules/.bin` first:

- Python type checking and navigation: project `ty`
- Python linting and code actions: project `ruff`
- TypeScript navigation: project `tsc --lsp`
- Configured web-project linting: project Oxlint or Biome; project ESLint via
  the Mason-managed `eslint-lsp`/`eslint_d` adapters
- Rust: `rust_analyzer`
- TOML: `taplo`
- HTML and Django templates: `html`
- CSS: `cssls`
- C#: `omnisharp`
- PHP: `intelephense`
- Lua formatting: `stylua`
- Lua: `lua_ls`

Ty and Ruff both discover project `pyproject.toml` files and `.venv`
environments. Their LSPs prefer project-local `.venv/bin` executables and fall
back to Mason. Ruff hover is disabled so ty exclusively owns Python hover and
type information, avoiding duplicate LSP responses.

Formatting and safe lint autofixes run synchronously before every normal file
save. Conform chooses tools from project markers rather than imposing one global
formatter and prefers executables from project `.venv` or `node_modules`
directories: Ruff or Black/isort for Python; Oxlint/Oxfmt, Biome, or
ESLint/Prettier for web projects (including MDX); and configured Stylua, rustfmt, clang-format, CSharpier,
PHP-CS-Fixer, shfmt, or Taplo projects. The attached language server is the
fallback when no explicit project formatter is selected. `<leader>F` runs the
same fix-and-format pipeline manually.

The HTML server is enabled for both `html` and `htmldjango`, with embedded CSS
and JavaScript support. Lua LSP formatting is disabled so project-configured
Stylua is used instead.

JavaScript and TypeScript use Neovim's `tsgo` configuration. It searches upward
for the monorepo's `node_modules/.bin/tsc` and starts that exact project version
with `--lsp --stdio`, falling back to `PATH` only when no local TypeScript exists.
Oxlint uses the same project-local resolution and Oxfmt is selected whenever an
Oxfmt configuration is present.

Completion uses `blink.cmp` with the `enter` preset, LSP/path/snippet sources,
LuaSnip snippets, hidden automatic documentation, Lua fuzzy matching, and
signature help.

## Web templates and Tree-sitter

The configuration installs parsers for Bash, C, CSS, diff, HTML, JavaScript,
Lua/Luadoc, Markdown, queries, Rust, TOML, Vimscript, YAML, and Vim help. Parsers
are attached automatically and installed on demand when a supported filetype
is opened. `.mdx` files use the MDX language server, while `mdx.nvim` combines
Markdown with TypeScript/TSX Tree-sitter injections for imports and JSX. MDX
files must be included by the project's `tsconfig.json` for component JSDoc,
types, and source definitions to resolve correctly.

- Django templates keep the `htmldjango` filetype while using the HTML parser.
- TypeScript/JavaScript buffers extract embedded CSS and HTML through Otter.
- Django templates extract embedded JavaScript and CSS through Otter.
- Lit `css` and `html` tagged templates receive CSS/HTML Tree-sitter
  injections via `after/queries/typescript/injections.scm`.
- Standalone Lit `${...}` interpolations are ignored when extracting CSS.
- `treesitter-context` keeps the current symbol context visible while scrolling.

## What is still Kickstart

The configuration retains Kickstart's documented single-file structure and its
core plugins/features: `guess-indent`, `gitsigns`, `which-key`, `todo-comments`,
`mini.nvim`, Telescope with FZF native and UI select, Fidget, LSP configuration
through `nvim-lspconfig`/Mason, Conform, LuaSnip, blink.cmp, and automatic
Tree-sitter highlighting/indentation. The comments in `init.lua` remain the
most detailed reference for extending those pieces.
