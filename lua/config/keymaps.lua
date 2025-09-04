-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>dv", function()
  require("dap.ui.widgets").hover()
end, { desc = "DAP Hover" })

vim.keymap.set("n", "<leader>dc", function()
  require("nvim-dap-virtual-text").refresh()
end, { desc = "Clear/Refresh DAP Virtual Text" })
