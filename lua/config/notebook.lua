local M = {}

local default_kernel = "python3"
M.kernel = nil

local function project_root(bufnr)
  bufnr = bufnr or 0
  local name = vim.api.nvim_buf_get_name(bufnr)
  local start = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()

  return vim.fs.root(start, {
    "uv.lock",
    "pyproject.toml",
    "requirements.txt",
    "setup.py",
    "setup.cfg",
    "pyrightconfig.json",
    ".git",
  }) or vim.uv.cwd()
end

local function shell_error(output)
  return (output or ""):gsub("%s+$", "")
end

local function kernel_name(root, venv)
  if not venv or venv == "" then
    return default_kernel
  end

  local project = vim.fn.fnamemodify(root or vim.uv.cwd(), ":t")
  project = project:gsub("[^%w_-]", "-"):lower()

  local hash = vim.fn.sha256(vim.fs.normalize(venv)):sub(1, 8)
  return ("uv-%s-%s"):format(project, hash)
end

local function kernel_exists(name)
  local ok, kernels = pcall(vim.fn.MoltenAvailableKernels)
  if not ok then
    return false
  end

  for _, kernel in ipairs(kernels or {}) do
    if kernel == name then
      return true
    end
  end

  return false
end

local function ensure_project_kernel(name, python, root)
  if name == default_kernel or kernel_exists(name) then
    return true
  end

  vim.fn.system({ python, "-c", "import ipykernel" })
  if vim.v.shell_error ~= 0 then
    vim.notify(
      ("Project kernel needs ipykernel. Run: uv pip install --python %s ipykernel"):format(python),
      vim.log.levels.ERROR
    )
    return false
  end

  local display_name = ("Python (%s)"):format(vim.fn.fnamemodify(root or vim.uv.cwd(), ":t"))
  local output = vim.fn.system({
    python,
    "-m",
    "ipykernel",
    "install",
    "--user",
    "--name",
    name,
    "--display-name",
    display_name,
  })

  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to register project kernel: " .. shell_error(output), vim.log.levels.ERROR)
    return false
  end

  return true
end

function M.current_kernel()
  local python_config = require("config.python")
  local root = project_root(0)
  local venv = python_config.venv(root)
  local python = python_config.python_path(root)

  return kernel_name(root, venv), python, root
end

function M.init(kernel)
  local python
  local root

  if kernel then
    M.kernel = kernel
  else
    M.kernel, python, root = M.current_kernel()
    if not ensure_project_kernel(M.kernel, python, root) then
      return false
    end
  end

  vim.cmd(("MoltenInit %s"):format(M.kernel))
  return true
end

local function ensure_initialized()
  if M.kernel then
    return true
  end

  return M.init()
end

function M.run_line()
  if not ensure_initialized() then
    return
  end

  vim.cmd("MoltenEvaluateLine")
end

function M.run_visual()
  if not ensure_initialized() then
    return
  end

  vim.cmd("'<,'>MoltenEvaluateVisual")
end

function M.run_cell()
  if not ensure_initialized() then
    return
  end

  local current = vim.api.nvim_win_get_cursor(0)[1]
  local start_marker = vim.fn.search([[^#\s*%%]], "bnW")
  local next_marker = vim.fn.search([[^#\s*%%]], "nW")

  local start_line = start_marker > 0 and start_marker + 1 or 1
  local end_line = next_marker > 0 and next_marker - 1 or vim.fn.line("$")

  if current == start_marker then
    start_line = current + 1
  end

  while start_line <= end_line and vim.fn.getline(start_line):match("^%s*$") do
    start_line = start_line + 1
  end

  while end_line >= start_line and vim.fn.getline(end_line):match("^%s*$") do
    end_line = end_line - 1
  end

  if start_line > end_line then
    vim.notify("No code in this cell", vim.log.levels.WARN)
    return
  end

  vim.fn.MoltenEvaluateRange(M.kernel, start_line, end_line)
end

return M
