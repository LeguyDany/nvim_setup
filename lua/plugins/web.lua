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
      javascript = get_formatter,
      javascriptreact = get_formatter,
      typescript = get_formatter,
      typescriptreact = get_formatter,
      json = { "prettier" },
      css = { "prettier" },
      mjs = get_formatter,
    },
  },
}
