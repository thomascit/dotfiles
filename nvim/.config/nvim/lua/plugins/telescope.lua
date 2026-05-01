return {
    'nvim-telescope/telescope.nvim',

    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
        },
    },
    config = function()
        local telescope = require('telescope')
        local builtin = require('telescope.builtin')

        telescope.setup({
            defaults = {
                prompt_prefix = '  ',
                selection_caret = ' ',
                sorting_strategy = 'ascending',
                layout_config = {
                    horizontal = {
                        prompt_position = 'top',
                        preview_width = 0.55,
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = 'smart_case',
                },
            },
        })

        pcall(telescope.load_extension, 'fzf')

        -- Keymaps
        vim.keymap.set('n', '<leader>ff', builtin.find_files,           { desc = 'Find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep,            { desc = 'Live grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers,              { desc = 'Buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags,            { desc = 'Help tags' })
        vim.keymap.set('n', '<leader>fr', builtin.oldfiles,             { desc = 'Recent files' })
        vim.keymap.set('n', '<leader>f:', builtin.commands,             { desc = 'Commands' })
        vim.keymap.set('n', '<leader>fd', builtin.diagnostics,          { desc = 'Diagnostics' })
        vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Document symbols' })
        vim.keymap.set('n', '<leader>f/', builtin.current_buffer_fuzzy_find, { desc = 'Fuzzy find in buffer' })
        vim.keymap.set('n', '<leader>fp', function()
            builtin.find_files({ cwd = '~/Projects', prompt_title = 'Projects' })
        end, { desc = 'Find in ~/Projects' })
        vim.keymap.set('n', '<leader>fP', function()
            builtin.live_grep({ cwd = '~/Projects', prompt_title = 'Grep Projects' })
        end, { desc = 'Grep ~/Projects' })
        vim.keymap.set('n', '<leader>fc', function()
            builtin.find_files({ cwd = '~/.config', hidden = true, follow = true, prompt_title = 'Config Files' })
        end, { desc = 'Find in ~/.config' })
        vim.keymap.set('n', '<leader>fC', function()
            local args = vim.deepcopy(require('telescope.config').values.vimgrep_arguments)
            table.insert(args, '--follow')
            builtin.live_grep({ cwd = '~/.config', vimgrep_arguments = args, prompt_title = 'Grep Config' })
        end, { desc = 'Grep ~/.config' })
    end,
}
