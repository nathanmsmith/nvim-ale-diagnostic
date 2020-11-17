local ale_diagnostic_severity_map = {
  [vim.lsp.protocol.DiagnosticSeverity.Error] = "E";
  [vim.lsp.protocol.DiagnosticSeverity.Warning] = "W";
  [vim.lsp.protocol.DiagnosticSeverity.Information] = "I";
  [vim.lsp.protocol.DiagnosticSeverity.Hint] = "H";
}

-- Mostly copied from Neovim's implementation:
-- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/diagnostic.lua#L778-L801
vim.lsp.diagnostic.clear = function(bufnr, client_id, diagnostic_ns, sign_ns)
  validate { bufnr = { bufnr, 'n' } }

  bufnr = (bufnr == 0 and api.nvim_get_current_buf()) or bufnr

  if client_id == nil then
    return vim.lsp.for_each_buffer_client(bufnr, function(_, iter_client_id, _)
      return vim.lsp.diagnostic.clear(bufnr, iter_client_id)
    end)
  end

  diagnostic_ns = diagnostic_ns or M._get_diagnostic_namespace(client_id)
  sign_ns = sign_ns or M._get_sign_namespace(client_id)

  assert(bufnr, "bufnr is required")
  assert(diagnostic_ns, "Need diagnostic_ns, got nil")
  assert(sign_ns, string.format("Need sign_ns, got nil %s", sign_ns))

  -- Clear ALE
  vim.api.nvim_call_function('ale#other_source#ShowResults', {bufnr, "nvim-lsp", {}})

  -- clear virtual text namespace
  api.nvim_buf_clear_namespace(bufnr, diagnostic_ns, 0, -1)

end

vim.lsp.diagnostic.set_signs = function(diagnostics, bufnr, _, _, _)
  if not diagnostics then
    return
  end

  local items = {}
  for _, item in ipairs(diagnostics) do
    table.insert(items, {
      nr = item.code,
      text = item.message,
      lnum = item.range.start.line+1,
      end_lnum = item.range['end'].line,
      col = item.range.start.character+1,
      end_col = item.range['end'].character,
      type = ale_diagnostic_severity_map[item.severity]
    })
  end

  vim.api.nvim_call_function('ale#other_source#ShowResults', {bufnr, "nvim-lsp", items})
end
