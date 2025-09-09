-- Plugins
local dracula_theme = require("yatline-dracula"):setup()

require("zoxide"):setup {
	update_db = true,
}

require("full-border"):setup({
    type = ui.Border.ROUNDED,
})

require("git"):setup()

require("starship"):setup()

require("yatline"):setup({
	show_background = true,
    theme = dracula_theme,
	header_line = {
		left = {
			section_a = {
			},
			section_b = {
			},
			section_c = {
			}
		},
		right = {
			section_a = {
			},
			section_b = {
			},
			section_c = {
			}
		}
	},
	status_line = {
		left = {
			section_a = {
        			{type = "string", custom = false, name = "tab_mode"},
			},
			section_b = {
        			{type = "string", custom = false, name = "hovered_size"},
			},
			section_c = {
        			{type = "string", custom = false, name = "hovered_name"},
			}
		},
		right = {
			section_a = {
        			{type = "string", custom = false, name = "cursor_position"},
			},
			section_b = {
        			{type = "string", custom = false, name = "cursor_percentage"},
			},
			section_c = {
        			{type = "coloreds", custom = false, name = "permissions"},
			}
		}
	},
})
