-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Restore Vim's native substitute behavior. LazyVim/flash.nvim maps `s` to
-- jump/search, but normal Vim uses `s` as `cl` and `S` as `cc`.
vim.keymap.set("n", "s", "cl", { desc = "Substitute character" })
vim.keymap.set("n", "S", "cc", { desc = "Substitute line" })
vim.keymap.set("x", "s", "c", { desc = "Substitute selection" })
vim.keymap.set("x", "S", "c", { desc = "Substitute selection" })
