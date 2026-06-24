return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    cmd = {
      "MoltenInit",
      "MoltenEvaluateLine",
      "MoltenEvaluateOperator",
      "MoltenEvaluateVisual",
      "MoltenReevaluateCell",
      "MoltenShowOutput",
      "MoltenHideOutput",
      "MoltenDelete",
    },
    init = function()
      vim.g.molten_auto_open_output = false
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    keys = {
      { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "Initialize Molten", ft = "python" },
      { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Evaluate line", ft = "python" },
      { "<leader>me", "<cmd>MoltenEvaluateOperator<cr>", desc = "Evaluate operator", ft = "python" },
      { "<leader>me", ":<C-u>MoltenEvaluateVisual<cr>", desc = "Evaluate selection", mode = "v", ft = "python" },
      { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "Re-evaluate cell", ft = "python" },
      { "<leader>mo", "<cmd>MoltenShowOutput<cr>", desc = "Show output", ft = "python" },
      { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = "Hide output", ft = "python" },
      { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Delete cell", ft = "python" },
    },
  },
}
