local M = {}

local function current_cell_bounds()
  local current = vim.api.nvim_win_get_cursor(0)[1]
  local last = vim.fn.line("$")
  local marker = nil

  for line = current, 1, -1 do
    if vim.fn.getline(line):match("^%s*#%s*%%%%") then
      marker = line
      break
    end
  end

  if marker then
    local next_marker = nil
    for line = marker + 1, last do
      if vim.fn.getline(line):match("^%s*#%s*%%%%") then
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

    return start_line, end_line
  end

  local start_line = current
  local end_line = current

  while start_line > 1 and not vim.fn.getline(start_line - 1):match("^%s*$") do
    start_line = start_line - 1
  end

  while end_line < last and not vim.fn.getline(end_line + 1):match("^%s*$") do
    end_line = end_line + 1
  end

  return start_line, end_line
end

local function lines(start_line, end_line)
  return vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
end

local function send(lines_to_send)
  require("iron.core").send(vim.bo.filetype, lines_to_send)
end

function M.send_cell()
  local start_line, end_line = current_cell_bounds()

  if start_line > end_line then
    vim.notify("No code in this cell", vim.log.levels.WARN)
    return
  end

  send(lines(start_line, end_line))
end

function M.send_visual()
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  send(lines(start_line, end_line))
end

function M.send_line()
  send({ vim.api.nvim_get_current_line() })
end

return M
