-- transparent.nvim: universal, theme-agnostic background clearing.
--
-- Owns `vim.g.transparent_enabled`, caches the on/off state across restarts,
-- and re-applies automatically after a colorscheme change. This replaces the
-- previous hand-rolled config/transparency.lua module.
--
-- Toggle is bound to <leader>tt in config/keymaps.lua via :TransparentToggle.
-- Avoid lazy-loading per the plugin's documentation.

return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    -- Keep floating windows readable (Lazy, Mason, Telescope, LspInfo, etc.).
    exclude_groups = { "NormalFloat", "FloatBorder" },
    -- Clear file-tree background in addition to the defaults.
    extra_groups = { "NeoTreeNormal", "NeoTreeNormalNC" },
    on_clear = function()
      -- Plugins that define highlights dynamically (icons, etc.) need their
      -- whole prefix cleared rather than individual groups.
      require("transparent").clear_prefix("lualine")
      require("transparent").clear_prefix("NeoTree")
    end,
  },
}
