return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- eslint = {
      --   settings = {
      --     format = false,
      --   },
      --   -- Restrict ESLint to specific directories (your backend)
      --   root_dir = function(fname)
      --     local util = require("lspconfig.util")
      --     -- Only attach ESLint if we're in a directory with eslint config
      --     -- This way it won't interfere with your frontend
      --     return util.root_pattern(".eslint.config.mjs", ".eslintrc.js", ".eslintrc.json", ".eslintrc")(fname)
      --   end,
      -- },
    },
    ts_ls = {
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          -- Enhanced diagnostics for better error reporting
          preferences = {
            includeCompletionsForModuleExports = true,
            includeCompletionsForImportStatements = true,
          },
          suggest = {
            includeCompletionsForModuleExports = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
      -- Enhanced initialization options
      init_options = {
        preferences = {
          disableSuggestions = false,
        },
      },
    },
  },
}
