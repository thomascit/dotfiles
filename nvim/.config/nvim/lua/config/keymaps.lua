-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Insert mode mappings
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Wrap mappings
vim.keymap.set("n", "<leader>tw", function()
  local on = vim.wo.wrap
  vim.wo.wrap = not on
  vim.wo.linebreak = not on
  vim.wo.breakindent = not on
end, { desc = "Wrap: toggle for window" })

vim.keymap.set("n", "<leader>tc", function()
  local has_column = vim.wo.colorcolumn ~= ""
  vim.wo.colorcolumn = has_column and "" or "80"
end, { desc = "Colorcolumn: toggle" })
