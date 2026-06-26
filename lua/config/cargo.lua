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

return M
