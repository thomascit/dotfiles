return {
  'nvim-mini/mini.nvim',
  version = false,
  config = function()
    require('mini.ai').setup()
    require('mini.icons').setup({
      filetype = {
        -- Use console icon and green color for shell scripts
        sh = { glyph = '󰆍', hl = 'MiniIconsGreen' },
      },
    })
    require('mini.pairs').setup()

    -- Defer mini.trailspace setup until user opens a real file
    -- This prevents red blocks on dashboard ASCII art at startup
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      once = true,
      callback = function()
        require('mini.trailspace').setup()
      end,
    })
  end,
}
