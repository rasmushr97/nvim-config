return {
  {
    "Vigemus/iron.nvim",
    ft = "python",
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")

      local function python_command()
        local python = require("config.python").python_path()

        vim.fn.system({ python, "-c", "import IPython" })
        if vim.v.shell_error == 0 then
          return { python, "-m", "IPython", "--no-autoindent" }
        end

        return { python, "-i", "-q" }
      end

      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = python_command,
              format = common.bracketed_paste_python,
            },
          },
          repl_open_cmd = view.right(80),
        },
        ignore_blank_lines = true,
      })
    end,
    keys = {
      { "<leader>pi", "<cmd>IronRepl<cr>", desc = "Open Python REPL", ft = "python" },
      { "<leader>pr", "<cmd>IronRestart<cr>", desc = "Restart Python REPL", ft = "python" },
      { "<leader>pf", "<cmd>IronFocus<cr>", desc = "Focus Python REPL", ft = "python" },
      { "<leader>ph", "<cmd>IronHide<cr>", desc = "Hide Python REPL", ft = "python" },
      { "<leader>pl", function() require("config.notebook").send_line() end, desc = "Send line to REPL", ft = "python" },
      { "<leader>pc", function() require("config.notebook").send_cell() end, desc = "Send # %% cell to REPL", ft = "python" },
      { "<leader>pc", function() require("config.notebook").send_visual() end, desc = "Send selection to REPL", mode = "v", ft = "python" },
    },
  },
}
