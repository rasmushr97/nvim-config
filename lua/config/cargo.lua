local M = {}

local is_windows = vim.fn.has("win32") == 1
local path_sep = is_windows and ";" or ":"

local function normalize(path)
  if not path or path == "" then
    return nil
  end
  return vim.fs.normalize(path)
end

local function exists(path)
  return path and (vim.uv or vim.loop).fs_stat(path) ~= nil
end

local function prepend_path(dir)
  dir = normalize(dir)
  if not exists(dir) then
    return
  end

  local current = vim.env.PATH or ""
  local needle = dir:lower()
  for entry in current:gmatch("[^" .. path_sep .. "]+") do
    if normalize(entry) and normalize(entry):lower() == needle then
      return
    end
  end

  vim.env.PATH = dir .. path_sep .. current
end

function M.setup()
  local home = normalize(vim.env.USERPROFILE or vim.env.HOME or vim.fn.expand("~"))
  local cargo_home = normalize(vim.env.CARGO_HOME) or (home and normalize(home .. "/.cargo"))
  local rustup_home = normalize(vim.env.RUSTUP_HOME) or (home and normalize(home .. "/.rustup"))

  if cargo_home then
    vim.env.CARGO_HOME = cargo_home
    prepend_path(cargo_home .. "/bin")
  end

  if rustup_home then
    vim.env.RUSTUP_HOME = rustup_home
  end
end

function M.reload_rust_analyzer_workspace()
  for _, client in ipairs(vim.lsp.get_clients({ name = "rust_analyzer" })) do
    client:request("workspace/executeCommand", {
      command = "rust-analyzer.reloadWorkspace",
      arguments = {},
    })
  end
end

function M.setup_autocmds()
  local group = vim.api.nvim_create_augroup("user_cargo", { clear = true })

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    pattern = { "Cargo.toml", "Cargo.lock" },
    callback = function()
      -- rust-analyzer can miss newly added crates until its workspace is reloaded.
      vim.schedule(M.reload_rust_analyzer_workspace)
    end,
  })

  vim.api.nvim_create_user_command("RustAnalyzerReload", function()
    M.reload_rust_analyzer_workspace()
    vim.notify("Reloaded rust-analyzer workspace")
  end, { desc = "Reload rust-analyzer workspace" })

  vim.api.nvim_create_user_command("LspRestart", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if vim.tbl_isempty(clients) then
      vim.notify("No active LSP clients for this buffer", vim.log.levels.INFO)
      return
    end

    for _, client in ipairs(clients) do
      client:stop(true)
    end

    vim.defer_fn(function()
      if vim.fn.exists(":LspStart") == 2 then
        vim.cmd("silent! LspStart")
      else
        vim.cmd("silent! edit")
        vim.cmd("silent! doautocmd <nomodeline> FileType")
      end
    end, 200)
  end, { desc = "Restart LSP clients for the current buffer" })
end

return M
