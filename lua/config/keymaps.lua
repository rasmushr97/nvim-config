-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- When pressing `j` on the last line, create a new line below and move to it.
-- Otherwise, keep normal `j` behavior.
vim.keymap.set("n", "j", function()
  if vim.v.count > 0 then
    return "j"
  end

  local line = vim.fn.line(".")
  if line == vim.fn.line("$") then
    vim.api.nvim_buf_set_lines(0, line, line, false, { "" })
  end

  return "j"
end, { expr = true, desc = "Down or create line at EOF" })
