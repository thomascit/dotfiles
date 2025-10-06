return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- Ensures parsers are updated on plugin updates
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Global configuration options for treesitter
      highlight = { enable = true }, -- Enable syntax highlighting
      indent = { enable = true },   -- Enable indentation
      ensure_installed = { "lua", "vim", "python" }, -- Example languages to install
      auto_install = true, -- Automatically install missing parsers on buffer open
      -- Further configurations can be added here
    })
  end,
}
