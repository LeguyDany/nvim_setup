return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- install language servers
        "lua-language-server",
        "python-lsp-server",
        "typescript-language-server",
        "rust-analyzer",
        "tailwindcss",

        -- install formatters
        "stylua",
        "prettierd", -- JS / TS
        "black", -- python
        "rustfmt", -- rust

        -- install debuggers
        "debugpy", -- Python
        "firefox-debug-adapter", -- Firefox JS / TS
        "codelldb", -- rust

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
  { "williamboman/mason.nvim" },
}
