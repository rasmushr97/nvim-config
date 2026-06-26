return {
  -- LazyVim's Python extra is enabled in lazyvim.json.
  -- This file keeps the user-specific Python choices explicit and easy for agents to modify.
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "basedpyright",
        "ruff",
        "debugpy",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local python = require("config.python")

      opts.servers = opts.servers or {}
      opts.servers.basedpyright = vim.tbl_deep_extend("force", opts.servers.basedpyright or {}, {
        before_init = python.lsp_before_init,
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "basic",
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      opts.servers.ruff = vim.tbl_deep_extend("force", opts.servers.ruff or {}, {
        before_init = python.lsp_before_init,
      })
    end,
  },

  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      options = {
        notify_user_on_venv_activation = true,
        override_notify = false,
      },
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Python venv", ft = "python" },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      local dap_python = require("dap-python")

      -- Use uv to run the debug adapter, while debug targets resolve to the active
      -- VIRTUAL_ENV or the project's .venv created by `uv sync`.
      dap_python.setup("uv")
      dap_python.resolve_python = function()
        return require("config.python").python_path()
      end
    end,
  },
}
