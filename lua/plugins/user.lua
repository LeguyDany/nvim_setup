return {
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = "<author> • <date> • <summary>  • <<sha>>",
      date_format = "%m-%d-%Y",
      virtual_text_column = 1,
    },
  },
  { "ThePrimeagen/harpoon" },
  {
    "hrsh7th/nvim-cmp",
    enabled = true,
  },
  {
    "Exafunction/windsurf.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
        -- Optional: enable virtual text suggestions
        virtual_text = {
          enabled = true,
          idle_delay = 100,
          map_keys = true,
        },
      })

      -- Inject Codeium as a cmp source
      local cmp = require("cmp")
      cmp.setup({
        sources = cmp.config.sources({
          { name = "codeium" },
        }, {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional
      "neovim/nvim-lspconfig", -- optional
    },
    opts = {}, -- your configuration
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
}
