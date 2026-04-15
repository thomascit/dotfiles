return{
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
        { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    },
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        lazygit = {
            configure = false
        },
        bigfile = { enabled = true },
        dashboard = {
            enabled = true,
            preset = {
                keys = {
                    { icon = " ", key = "p", desc = "Projects",         action = ":lua require('telescope.builtin').find_files({ cwd = '~/Projects', prompt_title = 'Projects' })" },
                    { icon = " ", key = "f", desc = "Find File",        action = ":lua require('telescope.builtin').find_files()" },
                    { icon = " ", key = "n", desc = "New File",         action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text",        action = ":lua require('telescope.builtin').live_grep()" },
                    { icon = " ", key = "r", desc = "Recent Files",     action = ":lua require('telescope.builtin').oldfiles()" },
                    { icon = " ", key = "c", desc = "Config",           action = ":lua require('telescope.builtin').find_files({ cwd = '~/.config', hidden = true, follow = true, prompt_title = 'Config Files' })" },
                    { icon = " ", key = "s", desc = "Restore Session",  section = "session" },
                    { icon = " ", key = "q", desc = "Quit",             action = ":qa" },
                },
            },
        },
        explorer = { enabled = false },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        toggle = { enabled = true },
        scroll = { enabled = false },
        zen = {
            enabled = true,
            toggles = {
                dim = true,
                git_signs = false,
                diagnostics = false,
            },
            win = {
                width = 80,
            },
        },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    },
}
