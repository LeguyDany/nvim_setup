local util = require("lspconfig.util")

local function get_formatter(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local has_prettier = util.root_pattern(".prettierrc")(fname)

  if has_prettier then
    return { "prettier" }
  else
    return { "eslint_d" }
  end
end

return {
  "stevearc/conform.nvim",
  lazy = false,
  opts = {
    formatters_by_ft = {
      javascript = { "eslint_d", "prettier" },
      typescript = { "eslint_d", "prettier" },
      javascriptreact = { "eslint_d", "prettier" },
      typescriptreact = { "eslint_d", "prettier" },
      json = { "prettier" },
      css = { "prettier" },
      mjs = get_formatter,
    },
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },
  },
}
