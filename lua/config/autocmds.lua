-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    -- Do not continue comments automatically when pressing Enter or o/O.
    -- This keeps `# %%` notebook cell markers from producing `# ` on the next line.
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

local diagnostics_float = vim.api.nvim_create_augroup("user_diagnostics_float", { clear = true })

vim.api.nvim_create_autocmd("CursorHold", {
  group = diagnostics_float,
  callback = function()
    vim.diagnostic.open_float(nil, {
      scope = "cursor",
      focus = false,
      close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" },
    })
  end,
})
