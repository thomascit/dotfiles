-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "dracula", "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
  ui = { border = "solid" },
})

-- Apply the persisted colorscheme. Deferred to VimEnter so it runs *after*
-- all start plugins (lazy = false) have finished their config functions and
-- after lazy's interim install colorscheme; otherwise the theme can be
-- clobbered during startup.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("theme_load", { clear = true }),
  callback = function()
    require("config.theme").load()
  end,
})
