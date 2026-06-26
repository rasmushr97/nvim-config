-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Restore Vim's native substitute behavior. LazyVim/flash.nvim maps `s` to
-- jump/search, but normal Vim uses `s` as `cl` and `S` as `cc`.
vim.keymap.set("n", "s", "cl", { desc = "Substitute character" })
vim.keymap.set("n", "S", "cc", { desc = "Substitute line" })
vim.keymap.set("x", "s", "c", { desc = "Substitute selection" })
vim.keymap.set("x", "S", "c", { desc = "Substitute selection" })

vim.keymap.set("n", "<leader>yd", function()
  local bufnr = 0
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })

  if vim.tbl_isempty(diagnostics) then
    vim.notify("No diagnostics on this line", vim.log.levels.INFO)
    return
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  local lines = vim.tbl_map(function(diagnostic)
    local severity = vim.diagnostic.severity[diagnostic.severity] or "UNKNOWN"
    local source = diagnostic.source and (" [" .. diagnostic.source .. "]") or ""
    local code = diagnostic.code and (" " .. diagnostic.code) or ""
    local message = diagnostic.message:gsub("\n", " ")

    return string.format(
      "%s:%d:%d: %s%s%s: %s",
      filename,
      diagnostic.lnum + 1,
      diagnostic.col + 1,
      severity,
      source,
      code,
      message
    )
  end, diagnostics)

  vim.fn.setreg("+", table.concat(lines, "\n"))
  vim.notify("Copied diagnostics to clipboard")
end, { desc = "Copy line diagnostics" })
