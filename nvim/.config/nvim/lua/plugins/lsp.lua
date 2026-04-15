---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      -- Show full diagnostic messages as virtual text by default
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many", -- show source if multiple (e.g., "pyright", "ruff")
        },
        float = {
          border = "rounded",
          source = true,
        },
        signs = true,
        underline = true,
        severity_sort = true,
      })

      -- Toggle diagnostic virtual text
      vim.keymap.set("n", "<leader>td", function()
        local current = vim.diagnostic.config().virtual_text
        if current then
          vim.diagnostic.config({ virtual_text = false })
          vim.notify("Diagnostics virtual text OFF", vim.log.levels.INFO)
        else
          vim.diagnostic.config({
            virtual_text = { prefix = "●", source = "if_many" },
          })
          vim.notify("Diagnostics virtual text ON", vim.log.levels.INFO)
        end
      end, { desc = "Toggle diagnostic virtual text" })

      -- LSP keymaps (set on LspAttach)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
          end

          -- Diagnostics
          map("gl", vim.diagnostic.open_float, "Show line diagnostics")
          map("]d", vim.diagnostic.goto_next, "Next diagnostic")
          map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")

          -- LSP
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gr", vim.lsp.buf.references, "Go to references")
          map("gI", vim.lsp.buf.implementation, "Go to implementation")
          map("gy", vim.lsp.buf.type_definition, "Go to type definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        end,
      })

      -- Configure LSP servers using vim.lsp.config (Neovim 0.11+)

      -- Python (type checking)
      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- Ruff (Python linting/formatting)
      vim.lsp.config("ruff", {
        on_attach = function(client)
          -- Disable hover in favor of pyright
          client.server_capabilities.hoverProvider = false
        end,
      })

      -- Lua (for Neovim config)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      -- TypeScript/JavaScript
      vim.lsp.config("ts_ls", {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
        },
      })

      -- Rust
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
            cargo = {
              allFeatures = true,
            },
          },
        },
      })

      -- Bash (no custom settings needed)
      vim.lsp.config("bashls", {})

      -- Setup mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "ruff",
          "lua_ls",
          "ts_ls",
          "rust_analyzer",
          "bashls",
        },
        automatic_enable = true, -- Auto-enable installed servers via vim.lsp.enable()
      })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
  },
}
