local opt = vim.opt

-- Line numbers
opt.number = true                    -- Show absolute line number on current line
opt.relativenumber = true            -- Show relative line numbers on other lines
opt.numberwidth = 8                  -- Make line number column wider (default is 4)

-- UI
opt.cursorline = true                -- Highlight current line
opt.showcmd = true                   -- Show command as you type
opt.showmatch = true                 -- Show matching brackets
opt.colorcolumn = "80"               -- Highlight column 80
opt.scroll = 10                      -- Set scroll to 10 lines
opt.scrolloff = 4                    -- Keep 4 lines visible above/below cursor

-- Mouse
opt.mouse = "a"                      -- Enable mouse support

-- Tabs and indentation
opt.tabstop = 4                      -- Number of spaces that a <Tab> counts for
opt.softtabstop = 4                  -- Number of spaces that a <Tab> counts for in insert mode
opt.shiftwidth = 4                   -- Number of spaces for autoindent
opt.expandtab = true                 -- Use spaces instead of tabs

-- Search
opt.incsearch = true                 -- Enable incremental search
opt.ignorecase = true                -- Ignore case when searching
opt.smartcase = true                 -- Override ignorecase if uppercase used
opt.hlsearch = true                  -- Highlight search matches

-- Clipboard
opt.clipboard = "unnamed"            -- Use system clipboard (macOS)
-- opt.clipboard = "unnamedplus"     -- Use system clipboard (Linux)

-- Performance
opt.ttyfast = true                   -- Faster scrolling
opt.timeout = true
opt.timeoutlen = 300

-- File handling
opt.hidden = true                    -- Allow hidden buffers (switch files without saving)
opt.swapfile = false                 -- Disable swap files
opt.undodir = vim.fn.expand("~/.nvim/undodir")  -- Directory to store undo history files
opt.undofile = true                  -- Enable persistent undo across sessions

-- Encoding
opt.encoding = "utf-8"               -- Set encoding

-- Wrapping
opt.wrap = false                     -- Disable line wrapping

-- Terminal
opt.termguicolors = true             -- Enable 24-bit RGB colors
