return {
  "Mofiqul/dracula.nvim",
  config = function()
    -- Setup dracula with options
    require("dracula").setup({
      transparent_bg = false, -- Enable transparent background
      italic_comment = true, -- Enable italic comments
      show_end_of_buffer = false, -- Hide ~ after end of buffer
    })

    -- Load the colorscheme after setup
    vim.cmd.colorscheme("dracula")

    -- Set DiagnosticOk to Dracula green (used by MiniIconsGreen)
    vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = "#50fa7b" })
  end,
}
