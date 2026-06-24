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
      -- Keep outputs visible inline after leaving the cell, notebook-style.
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true

      require("config.notebook").setup_autocmds()
    end,
    keys = {
      { "<leader>mi", function() require("config.notebook").init() end, desc = "Initialize Molten", ft = "python" },
      { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Evaluate line", ft = "python" },
      { "<leader>me", "<cmd>MoltenEvaluateOperator<cr>", desc = "Evaluate operator", ft = "python" },
      { "<leader>me", ":<C-u>MoltenEvaluateVisual<cr>gv", desc = "Evaluate selection", mode = "v", ft = "python" },
      { "<leader>mc", function() require("config.notebook").run_cell() end, desc = "Run Molten cell", ft = "python" },
      { "<leader>mc", function() require("config.notebook").run_visual_cell() end, desc = "Run Molten cell", mode = "v", ft = "python" },
      { "<leader>pt", function() require("config.notebook").open_python_terminal() end, desc = "Python terminal", ft = "python" },
      { "<leader>pc", function() require("config.notebook").run_cell_in_terminal() end, desc = "Run cell in terminal", ft = "python" },
      { "<leader>pc", function() require("config.notebook").run_visual_in_terminal() end, desc = "Run selection in terminal", mode = "v", ft = "python" },
      { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "Re-evaluate cell", ft = "python" },
      { "<leader>mo", "<cmd>noautocmd MoltenEnterOutput<cr>", desc = "Open output", ft = "python" },
      { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = "Hide output", ft = "python" },
      { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Delete cell", ft = "python" },
    },
  },
}
