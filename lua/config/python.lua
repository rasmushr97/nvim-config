local M = {}

local is_windows = package.config:sub(1, 1) == "\\"
local path_sep = is_windows and ";" or ":"

local function exists(path)
  return path and (vim.uv or vim.loop).fs_stat(path) ~= nil
end

local function python_in_venv(venv)
  if not venv or venv == "" then
    return nil
  end

  local python = is_windows and (venv .. "/Scripts/python.exe") or (venv .. "/bin/python")
  return exists(python) and vim.fs.normalize(python) or nil
end

local function project_root(bufnr)
  bufnr = bufnr or 0
  local name = vim.api.nvim_buf_get_name(bufnr)
  local start = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()

  return vim.fs.root(start, {
    ".venv",
    "uv.lock",
    "pyproject.toml",
    "requirements.txt",
    "setup.py",
    "setup.cfg",
    "pyrightconfig.json",
    ".git",
  }) or vim.uv.cwd()
end

function M.venv(root)
  root = root or project_root(0)
  local local_venv = root and (root .. "/.venv") or nil
  if python_in_venv(local_venv) then
    return vim.fs.normalize(local_venv)
  end

  if vim.env.VIRTUAL_ENV and python_in_venv(vim.env.VIRTUAL_ENV) then
    return vim.fs.normalize(vim.env.VIRTUAL_ENV)
  end

  return nil
end

function M.python_path(root)
  local venv = M.venv(root)
  return python_in_venv(venv) or vim.fn.exepath("python") or vim.fn.exepath("python3") or "python"
end

function M.python_host_path()
  local candidates = {}

  if vim.env.NVIM_PYTHON_HOST_PROG and vim.env.NVIM_PYTHON_HOST_PROG ~= "" then
    table.insert(candidates, vim.env.NVIM_PYTHON_HOST_PROG)
  end

  if is_windows and vim.env.USERPROFILE then
    table.insert(candidates, vim.env.USERPROFILE .. "/scoop/apps/python/current/python.exe")
  end

  table.insert(candidates, vim.fn.exepath("python"))
  table.insert(candidates, vim.fn.exepath("python3"))

  for _, python in ipairs(candidates) do
    if python and python ~= "" and exists(python) then
      vim.fn.system({ python, "-c", "import pynvim" })
      if vim.v.shell_error == 0 then
        return vim.fs.normalize(python)
      end
    end
  end

  return nil
end

function M.activate(root)
  local venv = M.venv(root)
  local python = M.python_path(root)

  if venv then
    vim.env.VIRTUAL_ENV = venv

    local bin = is_windows and (venv .. "/Scripts") or (venv .. "/bin")
    bin = vim.fs.normalize(bin)

    local path = vim.env.PATH or ""
    if not path:lower():find(vim.pesc(bin:lower()), 1) then
      vim.env.PATH = bin .. path_sep .. path
    end
  end

  return python, venv
end

function M.lsp_before_init(_, config)
  local root = config.root_dir or project_root(0)
  local python, venv = M.activate(root)

  config.settings = config.settings or {}
  config.settings.python = config.settings.python or {}
  config.settings.python.pythonPath = python

  config.cmd_env = vim.tbl_extend("force", config.cmd_env or {}, {
    VIRTUAL_ENV = venv,
    PATH = vim.env.PATH,
  })
end

function M.setup_autocmds()
  local group = vim.api.nvim_create_augroup("UserPythonVenv", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "python",
    callback = function(args)
      M.activate(project_root(args.buf))
    end,
  })
end

return M
