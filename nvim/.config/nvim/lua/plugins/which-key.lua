return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    local group = vim.api.nvim_create_augroup("WhichKeyVisualHooks", { clear = true })

    vim.api.nvim_create_autocmd("ModeChanged", {
      group = group,
      pattern = { "*:V", "*:\022" },
      callback = function(ev)
        wk.show("", { mode = ev.new_mode })
      end,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
      group = group,
      pattern = { "V:*", "\022:*" },
      callback = function()
        require("which-key.view").hide()
      end,
    })
  end,
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
