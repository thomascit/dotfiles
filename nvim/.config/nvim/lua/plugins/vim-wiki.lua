return {
  "vimwiki/vimwiki",
  init = function()
    vim.g.vimwiki_list = {
      { path = "~/Notes/", syntax = "markdown", ext = ".md" },
    }
    vim.g.vimwiki_global_ext = 0 -- Don't hijack .md files outside Notes/
  end,
}
