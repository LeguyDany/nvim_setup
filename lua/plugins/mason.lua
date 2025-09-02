return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- install language servers
        "lua-language-server",
        "python-lsp-server",
        "typescript-language-server",
        "tailwindcss",

        -- install formatters
        "stylua",
        "prettierd", -- JS / TS
        "black", -- python

        -- install debuggers
        "debugpy", -- Python
        "firefox-debug-adapter", -- Firefox JS / TS

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
  { "williamboman/mason.nvim" },
}
