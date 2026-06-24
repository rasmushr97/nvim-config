local M = {}

local default_kernel = "python3"

function M.init(kernel)
  kernel = kernel or default_kernel
  vim.cmd(("MoltenInit %s"):format(kernel))
end

local function ensure_initialized()
  pcall(M.init, default_kernel)
end

function M.run_line()
  ensure_initialized()
  vim.cmd("MoltenEvaluateLine")
end

function M.run_visual()
  ensure_initialized()
  vim.cmd("'<,'>MoltenEvaluateVisual")
end

function M.run_cell()
  ensure_initialized()

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

  vim.fn.MoltenEvaluateRange(default_kernel, start_line, end_line)
end

return M
