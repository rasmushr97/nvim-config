return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    lazy = false,
    init = function()
      vim.g.molten_auto_open_output = false
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true

      local function with_molten(callback)
        callback(require("config.notebook"))
      end

      vim.api.nvim_create_user_command("NotebookInit", function()
        with_molten(function(notebook)
          notebook.init()
        end)
      end, {})

      vim.api.nvim_create_user_command("NotebookRunCell", function()
        with_molten(function(notebook)
          notebook.run_cell()
        end)
      end, {})

      vim.api.nvim_create_user_command("NotebookRunLine", function()
        with_molten(function(notebook)
          notebook.run_line()
        end)
      end, {})
    end,
    keys = {
      { "<leader>mi", function() require("config.notebook").init() end, desc = "Initialize Molten", ft = "python" },
      { "<leader>mc", function() require("config.notebook").run_cell() end, desc = "Run # %% cell", ft = "python" },
      { "<leader>ml", function() require("config.notebook").run_line() end, desc = "Evaluate line", ft = "python" },
      { "<leader>me", "<cmd>MoltenEvaluateOperator<cr>", desc = "Evaluate operator", ft = "python" },
      { "<leader>me", function() require("config.notebook").run_visual() end, desc = "Evaluate selection", mode = "v", ft = "python" },
      { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "Re-evaluate cell", ft = "python" },
      { "<leader>mo", "<cmd>noautocmd MoltenEnterOutput<cr>", desc = "Open output", ft = "python" },
      { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = "Hide output", ft = "python" },
      { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Delete cell", ft = "python" },
    },
  },
}
