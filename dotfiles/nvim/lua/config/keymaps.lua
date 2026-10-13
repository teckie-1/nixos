-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("n", "<leader>qq", function()
  vim.cmd("w | bdelete")
  require("nvim-tree.api").tree.open()
end, { desc = "Save + close buffer + open file tree" })
