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

local inlay_hints = vim.api.nvim_create_augroup("user_inlay_hints", { clear = true })

local function set_inlay_hints(enabled, bufnr)
  if not vim.lsp.inlay_hint then
    vim.notify("Inlay hints are not supported by this Neovim version", vim.log.levels.WARN)
    return
  end

  vim.lsp.inlay_hint.enable(enabled, { bufnr = bufnr or 0 })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = inlay_hints,
  callback = function(event)
    -- Keep type/inlay hints hidden by default. Use :InlayHintsEnable when needed.
    set_inlay_hints(false, event.buf)
  end,
})

vim.api.nvim_create_user_command("InlayHintsEnable", function()
  set_inlay_hints(true)
end, { desc = "Show LSP inlay/type hints in the current buffer" })

vim.api.nvim_create_user_command("InlayHintsDisable", function()
  set_inlay_hints(false)
end, { desc = "Hide LSP inlay/type hints in the current buffer" })

vim.api.nvim_create_user_command("InlayHintsToggle", function()
  if not vim.lsp.inlay_hint then
    vim.notify("Inlay hints are not supported by this Neovim version", vim.log.levels.WARN)
    return
  end

  set_inlay_hints(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
end, { desc = "Toggle LSP inlay/type hints in the current buffer" })
