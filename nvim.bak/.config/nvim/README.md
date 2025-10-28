# Neovim Configuration Structure

This is a recommended directory structure for a modern, modular Neovim configuration.

## Directory Layout

```
~/.config/nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── config/             # Core configuration
│   │   ├── autocmds.lua    # Autocommands
│   │   ├── keymaps.lua     # Key mappings
│   │   ├── lazy.lua        # Plugin manager setup
│   │   └── options.lua     # Neovim options
│   └── plugins/            # Plugin configurations
│       ├── lsp.lua         # LSP setup
│       ├── treesitter.lua  # Syntax highlighting
│       ├── telescope.lua   # Fuzzy finder
│       ├── cmp.lua         # Completion
│       └── ui.lua          # UI enhancements
├── after/
│   └── ftplugin/          # Filetype-specific settings
│       ├── python.lua
│       └── javascript.lua
└── snippets/              # Custom snippets
    ├── python.json
    └── javascript.json
```

## Structure Explanation

### `init.lua`
The main entry point for your Neovim configuration. This file should be minimal and primarily used to require your modular configuration files.

### `lua/config/`
Core Neovim settings separated from plugin configurations:
- **autocmds.lua**: Autocommands for various events
- **keymaps.lua**: Global key mappings
- **lazy.lua**: Plugin manager (lazy.nvim) setup and initialization
- **options.lua**: Neovim options (line numbers, tabs, etc.)

### `lua/plugins/`
Individual plugin configurations for better organization:
- **lsp.lua**: Language Server Protocol setup
- **treesitter.lua**: Syntax highlighting and code understanding
- **telescope.lua**: Fuzzy finder configuration
- **cmp.lua**: Auto-completion setup
- **ui.lua**: UI enhancements (statusline, themes, etc.)
