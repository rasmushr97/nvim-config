return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diff uncommitted changes" },
      { "<leader>gC", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
    },
  },
}
