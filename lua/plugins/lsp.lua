return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Type/inlay hints are noisy by default. Use :InlayHintsEnable or
      -- :InlayHintsToggle when you want to inspect them temporarily.
      inlay_hints = { enabled = false },
    },
  },
}
