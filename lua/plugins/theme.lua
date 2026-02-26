-- Return a list of plugins to load
return {
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "mocha",
  --     })
  --     vim.cmd.colorscheme("catppuccin")
  --   end,
  -- },

  -- Tokyonight colorscheme
  {
    "folke/tokyonight.nvim", -- plugin repo
    lazy = false, -- load immediately
    priority = 1000, -- load before everything else

    config = function()
      -- Set the theme style
      require("tokyonight").setup({
        style = "night", -- night / storm / moon / day
      })

      -- Apply the colorscheme
      vim.cmd("colorscheme tokyonight")
    end,
  },
}
