-- Plugins

require("zoxide"):setup({
	update_db = false,
})

require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.PLAIN,
})

require("git"):setup()
