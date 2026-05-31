return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
  opts = {},
  config = function(_, opts)
    -- Remove backgrounds from all heading levels
    for i = 1, 6 do
      vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i .. "Bg", { bg = "NONE" })
    end

    require("render-markdown").setup(opts)
  end,
}
