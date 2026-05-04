-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Insert mode mappings
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Keep highlight after yank
map("v", "y", "ygv", { noremap = true })

-- Wrap mappings
map("n", "<leader>tw", function()
  local on = vim.wo.wrap
  vim.wo.wrap = not on
  vim.wo.linebreak = not on
  vim.wo.breakindent = not on
end, { desc = "Wrap" })

-- Colorcolumn
map("n", "<leader>tc", function()
  local has_column = vim.wo.colorcolumn ~= ""
  vim.wo.colorcolumn = has_column and "" or "80"
end, { desc = "Colorcolumn" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>qb", function()
  Snacks.bufdelete()
end, { desc = "Quit Buffer" })
map("n", "<leader>qo", function()
  Snacks.bufdelete.other()
end, { desc = "Quit Other Buffers" })
map("n", "<leader>qa", function()
  Snacks.bufdelete.all()
end, { desc = "Quit All Buffers" })

-- Save
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- New File
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- lazygit
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gg", function()
    Snacks.lazygit({ cwd = LazyVim.root.git() })
  end, { desc = "Lazygit (Root Dir)" })
  map("n", "<leader>gG", function()
    Snacks.lazygit()
  end, { desc = "Lazygit (cwd)" })
end

map("n", "<leader>gL", function()
  Snacks.picker.git_log()
end, { desc = "Git Log (cwd)" })
map("n", "<leader>gb", function()
  Snacks.picker.git_log_line()
end, { desc = "Git Blame Line" })
map("n", "<leader>gf", function()
  Snacks.picker.git_log_file()
end, { desc = "Git Current File History" })
map("n", "<leader>gl", function()
  Snacks.picker.git_log({ cwd = LazyVim.root.git() })
end, { desc = "Git Log" })
map({ "n", "x" }, "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git Browse (open)" })
map({ "n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({
    open = function(url)
      vim.fn.setreg("+", url)
    end,
    notify = false,
  })
end, { desc = "Git Browse (copy)" })

-- Format
map("n", "<leader>cF", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format (LSP only)" })

-- Clear search highlights
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- Buffer navigation
map("n", "H", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "L", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

-- Centered scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })
