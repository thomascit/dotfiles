return {
  "Mofiqul/dracula.nvim",
  config = function()
    -- Setup dracula with options
    require("dracula").setup({
      transparent_bg = true,  -- Enable transparent background
      italic_comment = true,  -- Enable italic comments
      show_end_of_buffer = false,  -- Hide ~ after end of buffer
    })
    
    -- Load the colorscheme after setup
    vim.cmd.colorscheme("dracula")
  end,
}
