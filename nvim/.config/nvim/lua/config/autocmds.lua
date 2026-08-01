vim.filetype.add({
  extension = {
    tf     = 'terraform',
    tfvars = 'terraform',
  },
})

-- Persist the active colorscheme whenever it changes (e.g. via the picker).
-- save() skips writes when the name is unchanged, so live-preview hovers do
-- not churn the tracked state file.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("theme_persist", { clear = true }),
  callback = function(args)
    require("config.theme").save(args.match)
  end,
})
