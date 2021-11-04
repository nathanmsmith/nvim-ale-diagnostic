local ale_diagnostic_severity_map = {
  [vim.lsp.protocol.DiagnosticSeverity.Error] = "E";
  [vim.lsp.protocol.DiagnosticSeverity.Warning] = "W";
  [vim.lsp.protocol.DiagnosticSeverity.Information] = "I";
  [vim.lsp.protocol.DiagnosticSeverity.Hint] = "I";
}

vim.lsp.diagnostic.original_clear = vim.lsp.diagnostic.clear
vim.lsp.diagnostic.clear = function(bufnr, client_id, diagnostic_ns, sign_ns)
  vim.lsp.diagnostic.original_clear(bufnr, client_id, diagnostic_ns, sign_ns)
  -- Clear ALE
  vim.api.nvim_call_function('ale#other_source#ShowResults', {bufnr, "nvim-lsp", {}})
end

if vim.version().api_level == 8 then
  local function set_signs(bufnr)
      -- Get all diagnostics from the current buffer
    local diagnostics = vim.diagnostic.get(bufnr)
    local items = {}

    for _, item in ipairs(diagnostics) do
      local nr = ''
      if item.user_data and item.user_data.lsp and item.user_data.lsp.code then
        nr = item.user_data.lsp.code
      end
      table.insert(items, {
        nr = nr,
        text = item.message,
        lnum = item.lnum+1,
        end_lnum = item.end_lnum,
        col = item.col+1,
        end_col = item.end_col,
        type = ale_diagnostic_severity_map[item.severity]
      })
    end

    vim.api.nvim_call_function('ale#other_source#ShowResults', {bufnr, "nvim-lsp", items})
  end

  function vim.diagnostic.show(namespace, bufnr, ...)
    set_signs(bufnr)
  end
else
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
end

