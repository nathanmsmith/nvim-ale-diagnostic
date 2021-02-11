# nvim-ale-diagnostic

Routes Neovim LSP diagnostics to ALE for display. Useful if you like to manage all your errors in the same way.

## Requirements

- Neovim nightly
- [ALE](https://github.com/dense-analysis/ale)

## Installation

```
Plug 'nathunsmitty/nvim-ale-diagnostic'

" or, if you use a Vim 8 package manager
call packager#add('nathunsmitty/nvim-ale-diagnostic', {'type': 'opt'})
packadd nvim-ale-diagnostic

" or your favorite package manager here
```

Then, put the following in a Lua file at `nvim/lua/lsp/init.lua`:

```lua
require("nvim-ale-diagnostic")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)
```

For an example of this in action, check out [my dotfiles](https://github.com/nathunsmitty/.config/blob/main/nvim/lua/lsp/init.lua).

## Notes

- `underline` and `virtual_text` are configurable, but you should probably disable them and configure those features through ALE.
- The default Neovim diagnostic signs are overriden by this plugin.
