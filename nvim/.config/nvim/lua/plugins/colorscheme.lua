-- Colorscheme plugins
--
-- All themes are installed eagerly (lazy = false, high priority) so the
-- Snacks colorscheme picker can live-preview them and so the persisted
-- theme (see config/theme.lua) can be applied at startup.
--
-- Each theme reads `vim.g.transparent_enabled`, which is owned by
-- transparent.nvim. This preserves each theme's *native* transparency
-- handling on top of transparent.nvim's universal background clearing.
--
-- NOTE: the active colorscheme is NOT set here. config/theme.lua loads the
-- persisted choice after lazy.setup() in config/lazy.lua.

return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("dracula").setup({
        transparent_bg = vim.g.transparent_enabled or false,
        italic_comment = true,
        show_end_of_buffer = false,
      })
      -- Set DiagnosticOk to Dracula green (used by MiniIconsGreen)
      vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = "#50fa7b" })
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "auto",
        transparent_background = vim.g.transparent_enabled or false,
        term_colors = true,
        integrations = {
          gitsigns = true,
          mason = true,
          mini = true,
          neotree = true,
          noice = true,
          snacks = true,
          telescope = true,
          treesitter = true,
          which_key = true,
        },
      })
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        transparent = vim.g.transparent_enabled or false,
      })
    end,
  },

  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        transparent_mode = vim.g.transparent_enabled or false,
      })
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        transparent = vim.g.transparent_enabled or false,
      })
    end,
  },

  {
    "oxfist/night-owl.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("night-owl").setup({
        transparent_background = vim.g.transparent_enabled or false,
      })
    end,
  },
}
