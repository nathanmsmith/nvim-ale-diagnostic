local ale_diagnostic_severity_map = {
  [vim.lsp.protocol.DiagnosticSeverity.Error] = "E";
  [vim.lsp.protocol.DiagnosticSeverity.Warning] = "W";
  [vim.lsp.protocol.DiagnosticSeverity.Information] = "I";
  [vim.lsp.protocol.DiagnosticSeverity.Hint] = "H";
}

local original_clear = vim.lsp.diagnostic.clear

vim.lsp.diagnostic.clear = function(bufnr, client_id, diagnostic_ns, sign_ns)
  original_clear(bufnr, client_id, diagnostic_ns, sign_ns)
  vim.api.nvim_call_function('ale#other_source#ShowResults', {bufnr, "nvim-lsp", {}})
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
