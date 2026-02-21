-- Return a list of plugins to load
return {

  -- Tokyonight colorscheme
  {
    "folke/tokyonight.nvim", -- plugin repo
    lazy = false, -- load immediately
    priority = 1000, -- load before everything else

    config = function()
      -- Set the theme style
      require("tokyonight").setup({
        style = "moon", -- night / storm / moon / day
      })

      -- Apply the colorscheme
      vim.cmd("colorscheme tokyonight")
    end,
  },
}
