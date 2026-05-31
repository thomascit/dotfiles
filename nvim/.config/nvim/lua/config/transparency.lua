-- Transparency helper module
-- Provides theme-agnostic transparency toggling

local M = {}

-- Initialize transparency state (defaults to off)
vim.g.transparent_enabled = vim.g.transparent_enabled == nil and false or vim.g.transparent_enabled

-- Theme-specific transparency configurations
local theme_configs = {
  dracula = {
    setup = function(enabled)
      require("dracula").setup({
        transparent_bg = enabled,
        italic_comment = true,
        show_end_of_buffer = false,
      })
    end,
    after = function()
      vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = "#50fa7b" })
    end,
  },
  catppuccin = {
    setup = function(enabled)
      require("catppuccin").setup({
        flavour = "auto", -- Respects the current catppuccin-* variant
        transparent_background = enabled,
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
}

-- Map colorscheme names to their base theme
local function get_theme_base(colorscheme)
  if colorscheme == "dracula" then
    return "dracula"
  elseif colorscheme:match("^catppuccin") then
    return "catppuccin"
  end
  return nil
end

-- Apply transparency to the current colorscheme
function M.apply(enabled)
  if enabled == nil then
    enabled = vim.g.transparent_enabled
  end

  local colorscheme = vim.g.colors_name or "default"
  local base = get_theme_base(colorscheme)

  if base and theme_configs[base] then
    local config = theme_configs[base]

    -- Re-setup the theme with new transparency setting
    if config.setup then
      config.setup(enabled)
    end

    -- Re-apply the colorscheme to activate changes
    vim.cmd.colorscheme(colorscheme)

    -- Run any post-setup hooks
    if config.after then
      config.after()
    end
  else
    -- Fallback: clear background highlight groups manually
    -- This works for most themes but may not be perfect
    if enabled then
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
    else
      -- Reload colorscheme to restore default backgrounds
      vim.cmd.colorscheme(colorscheme)
    end
  end
end

-- Toggle transparency and apply to current theme
function M.toggle()
  vim.g.transparent_enabled = not vim.g.transparent_enabled
  M.apply(vim.g.transparent_enabled)
  vim.notify("Transparency: " .. (vim.g.transparent_enabled and "ON" or "OFF"), vim.log.levels.INFO)
end

-- Check if transparency is currently enabled
function M.is_enabled()
  return vim.g.transparent_enabled
end

return M
