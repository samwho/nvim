# Sam's Neovim configuration

This is a personal fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
It keeps Kickstart's single-file, `vim.pack`-based setup, but adds a workflow
focused on Git, LSP diagnostics, web templates, code navigation, and a
keyboard-driven file tree.

The main configuration is [`init.lua`](init.lua). The other custom files are:

- [`after/queries/typescript/injections.scm`](after/queries/typescript/injections.scm) — Tree-sitter injections for Lit `css` and `html` tagged templates.
- [`lazygit.yml`](lazygit.yml) — LazyGit key behaviour.
- [`nvim-pack-lock.json`](nvim-pack-lock.json) — tracked plugin revisions for reproducible installs.

## Installation

### Requirements

Use a current stable or nightly Neovim. In addition to Neovim, the normal
Kickstart requirements apply:

- `git`, `make`, `unzip`, and a C compiler
- `ripgrep`, `fd`, and the Tree-sitter CLI
- An OS clipboard provider
- A selected [Nerd Font](https://www.nerdfonts.com/) (this configuration enables Nerd Font icons)
- `lazygit`, for `<leader>g`
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
| `<leader>ff` | Find a file with the custom Telescope layout |
| `<leader>sf` | Telescope file search |
| `<leader>fb` | Find an existing buffer |
| `<leader>sn` | Search Neovim configuration files |
| `<leader>/` | Fuzzy-search the current buffer |
| `<leader>w` | Hop to a labelled word |
| `<leader>o` | Toggle the Aerial code outline |
| `<C-h/j/k/l>` | Move to the left/down/up/right split |
| `H/J/K/L` | Faster split navigation in the same directions |
| `<Esc>` in normal mode | Clear search highlighting |
| `<Esc><Esc>` in terminal mode | Leave terminal mode |

Inside `nvim-tree`, `<Esc>` closes the tree, `/` starts live filtering, and
opening a file closes the tree. Dotfiles are shown; Git-ignored files remain
filtered.

### Search and LSP

| Mapping | Action |
| --- | --- |
| `gh` | Show the diagnostic at the cursor, or LSP hover when there is no error/warning |
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
| `<leader>y` in visual mode | Copy `relative/file: start-end` to the system clipboard |

The visual `<leader>y` mapping is intended for making file/line references for
Pi. Unnamed buffers are labelled `[No Name]`.

Other Telescope mappings include `<leader>sh` (help), `<leader>sk` (keymaps),
`<leader>ss` (Telescope pickers), `<leader>sw` (word), `<leader>sg` (live grep),
`<leader>sd` (diagnostics), `<leader>sr` (resume), `<leader>s.` (recent files),
`<leader>sc` (commands), and `<leader>s/` (grep open files).

### Git

| Mapping | Action |
| --- | --- |
| `<leader>g` | Open LazyGit |
| `<leader>d` | Toggle character-level inline diff highlighting |
| `gc` / `gC` | Next / previous Git hunk |
| `<leader>o` | Toggle the code outline (also useful while reviewing code) |

Git changes are shown with custom line signs and explicit Gruvbox diff colours.
`Satellite` adds a scrollbar containing diagnostics, search, marks, and Git
hunks. `Diffview` is configured for side-by-side review, without icons, and can
be opened with its normal commands such as `:DiffviewOpen`.

LazyGit is opened in a 90%-sized Neovim float. Its repository configuration
has automatic fetching disabled; `q` and `<Esc>` quit, while Return is
intentionally disabled (`lazygit.yml`).

## Diagnostics and hover documentation

Diagnostics use `tiny-inline-diagnostic.nvim` with the minimal, transparent
preset. Messages wrap at 30 columns, multiline messages are always shown, and
source/code labels are hidden. Neovim's competing virtual text and virtual
lines renderers are disabled. Diagnostic jumps automatically open a rounded,
unfocused float.

`gh` chooses an error or warning under the cursor before falling back to LSP
hover. Hover windows are rounded, titled `Hover`, wrapped, focused on open,
and limited to 80×15. Escape closes a hover. Inline `data:image/...` Markdown
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
- LazyGit is the active Git UI. Neogit is no longer configured (an older
  Neogit entry may remain in the pack lock until it is pruned).

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
- **lazygit.nvim** for the primary Git UI.
- **tiny-inline-diagnostic.nvim** for wrapped inline diagnostics.
- **nvim-treesitter-context** to keep up to three lines of function/class
  context visible while scrolling.
- **otter.nvim** for language-server support inside embedded web languages.

`mini.icons` remains enabled through Kickstart's `mini.nvim` setup, and the
Nerd Font is used in the statusline, Telescope, and plugin UIs.

The statusline is replaced with a compact custom layout containing:

- current mode
- Git branch
- added and removed lines in the current buffer
- the number of changed files in the repository, refreshed asynchronously
- the current filetype and its icon

It deliberately omits the default cursor line/column display.

## LSP, completion, and formatting

Mason is asked to install these servers/tools:

- Python: `pyright`
- Rust: `rust_analyzer`
- TOML: `taplo`
- HTML and Django templates: `html`
- CSS: `cssls`
- C#: `omnisharp`
- PHP: `intelephense`
- Lua formatting: `stylua`
- Lua: `lua_ls`

The HTML server is enabled for both `html` and `htmldjango`, with embedded CSS
and JavaScript support. Lua LSP formatting is disabled so Stylua is used
instead. Conform does not format on save by default: the whitelist is empty;
`<leader>F` is the manual formatting escape hatch and uses LSP formatting as a
fallback.

JavaScript and TypeScript use Neovim's `tsgo` configuration:

```text
cmd = { "tsc", "--lsp", "--stdio" }
```

It is enabled for JavaScript/TypeScript and their React variants, and expects
`tsc` to be available on `PATH`.

Completion uses `blink.cmp` with the `enter` preset, LSP/path/snippet sources,
LuaSnip snippets, hidden automatic documentation, Lua fuzzy matching, and
signature help.

## Web templates and Tree-sitter

The configuration installs parsers for Bash, C, CSS, diff, HTML, JavaScript,
Lua/Luadoc, Markdown, queries, Rust, TOML, Vimscript, and Vim help. Parsers
are attached automatically and installed on demand when a supported filetype
is opened.

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
