return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tailwindcss = {},
      eslint = {
        root_dir = function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern("eslint.config.js", "eslint.config.mjs")(fname)
        end,
        on_attach = function(client, bufnr)
          local util = require("lspconfig.util")
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local has_prettier = util.root_pattern(".prettierrc")(fname)

          if has_prettier then
            -- disable eslint's formatter if prettier is found
            client.server_capabilities.documentFormattingProvider = false
          end
        end,
        settings = {
          experimental = {
            useFlatConfig = true,
          },
          workingDirectory = {
            mode = "auto",
          },
        },
      },
      ts_ls = {
        settings = {
          typescript = {
            -- Enhanced diagnostics for better error reporting
            preferences = {
              includeCompletionsForModuleExports = true,
              includeCompletionsForImportStatements = true,
            },
            suggest = {
              includeCompletionsForModuleExports = true,
            },
          },
        },
        -- Enhanced initialization options
        init_options = {
          preferences = {
            importModuleSpecifier = "relative",
            disableSuggestions = false,
          },
        },
      },
    },
  },
}
