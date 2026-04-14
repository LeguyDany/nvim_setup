return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            inlayHints = {
              parameterHints = { enable = false },
              typeHints = { enable = false },
              chainingHints = { enable = false },
            },
          },
        },
      },
      tailwindcss = {},
      eslint = {
        on_attach = function(client, bufnr)
          local util = require("lspconfig.util")
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local has_prettier = util.root_pattern(".prettierrc")(fname)

          if has_prettier then
            -- disable eslint's formatter if prettier is found
            client.server_capabilities.documentFormattingProvider = false
          end
        end,
        -- ESLint 9 removed the FlatESLint class. lspconfig's default before_init
        -- auto-sets experimental.useFlatConfig = true when it detects a flat config,
        -- which forces the server to load the (now missing) FlatESLint class.
        before_init = function(_, config)
          local root_dir = config.root_dir
          config.settings = config.settings or {}
          if root_dir then
            config.settings.workspaceFolder = {
              uri = root_dir,
              name = vim.fn.fnamemodify(root_dir, ":t"),
            }
          end
          config.settings.experimental = config.settings.experimental or {}
          config.settings.experimental.useFlatConfig = false
        end,
        settings = {
          experimental = {
            useFlatConfig = false,
          },
          workingDirectory = {
            mode = "auto",
          },
        },
      },
      ts_ls = {
        settings = {
          javascript = {
            -- This is the key part: disable diagnostics for JS files
            validate = false,
            suggest = {
              names = true,
              paths = true,
            },
          },
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
