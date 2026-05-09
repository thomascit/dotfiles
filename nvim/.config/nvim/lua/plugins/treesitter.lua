return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "vim", "vimdoc", "python", "markdown", "markdown_inline", "yaml" },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
