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

Then, put the following in a Lua file at `nvim/lua/lsp-ale-diagnostic/init.lua`:

```lua
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)
```

Then source it from your `init.vim` file:

```
lua require("nvim-ale-diagnostic")
```

## Notes

- `underline` and `virtual_text` are configurable, but you should probably disable them and configure those features through ALE.
- The default Neovim diagnostic signs are overriden by this plugin.
