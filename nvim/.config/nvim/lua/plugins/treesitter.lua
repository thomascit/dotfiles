return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Add languages to be installed here
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "javascript",
        "typescript",
        "python",
        "html",
        "css",
        "json",
        "markdown",
        "markdown_inline",
      },
      
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      
      -- Automatically install missing parsers when entering buffer
      auto_install = true,
      
      highlight = {
        enable = true,
        -- Disable slow treesitter highlight for large files
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      
      indent = {
        enable = true,
      },
    })
  end,
}
