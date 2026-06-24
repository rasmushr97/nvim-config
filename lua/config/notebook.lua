local M = {}

local function define_cell(start_line, end_line)
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local ok, err = pcall(vim.fn.MoltenDefineCell, start_line, end_line)
  if not ok then
    vim.notify("MoltenDefineCell failed: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  vim.notify(("Molten cell defined: lines %d-%d"):format(start_line, end_line), vim.log.levels.INFO)
end

function M.define_visual_cell()
  define_cell(vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2])
end

local function is_percent_marker(line)
  return line:match("^%s*#%s*%%%%") ~= nil
end

function M.define_percent_cell()
  local current = vim.api.nvim_win_get_cursor(0)[1]
  local last = vim.fn.line("$")
  local marker = nil

  for line = current, 1, -1 do
    if is_percent_marker(vim.fn.getline(line)) then
      marker = line
      break
    end
  end

  if not marker then
    return false
  end

  local next_marker = nil
  for line = marker + 1, last do
    if is_percent_marker(vim.fn.getline(line)) then
      next_marker = line
      break
    end
  end

  local start_line = marker + 1
  local end_line = next_marker and (next_marker - 1) or last

  while start_line <= end_line and vim.fn.getline(start_line):match("^%s*$") do
    start_line = start_line + 1
  end

  while end_line >= start_line and vim.fn.getline(end_line):match("^%s*$") do
    end_line = end_line - 1
  end

  if start_line > end_line then
    vim.notify("No code in this # %% cell", vim.log.levels.WARN)
    return true
  end

  define_cell(start_line, end_line)
  return true
end

function M.define_paragraph_cell()
  if M.define_percent_cell() then
    return
  end

  local current = vim.api.nvim_win_get_cursor(0)[1]
  local last = vim.fn.line("$")
  local start_line = current
  local end_line = current

  while start_line > 1 and not vim.fn.getline(start_line - 1):match("^%s*$") do
    start_line = start_line - 1
  end

  while end_line < last and not vim.fn.getline(end_line + 1):match("^%s*$") do
    end_line = end_line + 1
  end

  define_cell(start_line, end_line)
end

return M
