-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Keep cursor jumps instant instead of animated.
vim.g.snacks_animate = false
vim.opt.smoothscroll = false

-- Python defaults. LazyVim reads these before loading the Python extra.
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

-- Prefer a project's uv/.venv Python when Neovim starts inside that project.
require("config.python").activate(vim.uv.cwd())
require("config.python").setup_autocmds()
