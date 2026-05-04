---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  keys = {
    {
      "<leader>e",
      "<cmd>Neotree toggle<cr>",
      desc = "Explorer (Neo-tree)",
    },
    {
      "<leader>fe",
      "<cmd>Neotree reveal<cr>",
      desc = "Reveal file in explorer",
    },
  },
  opts = {
    close_if_last_window = true,
    filesystem = {
      hijack_netrw_behavior = "open_current",
      follow_current_file = {
        enabled = true,
      },
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          ".git",
          ".DS_Store",
        },
      },
    },
    window = {
      width = 35,
      mappings = {
        ["<space>"] = "none", -- disable space so it doesn't conflict with leader
        ["l"] = "open",
        ["h"] = "close_node",
      },
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added = "",
          modified = "",
          deleted = "",
          renamed = "",
          untracked = "",
          ignored = "",
          unstaged = "",
          staged = "",
          conflict = "",
        },
      },
    },
  },
}
