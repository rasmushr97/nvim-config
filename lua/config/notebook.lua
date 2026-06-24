local M = {}

M.kernel = nil

local function active_kernel(opts)
  if M.kernel then
    return M.kernel
  end

  local ok, kernels = pcall(vim.fn.MoltenRunningKernels, true)
  kernels = ok and kernels or {}

  if #kernels == 1 then
    M.kernel = kernels[1]
    return M.kernel
  end

  if #kernels > 1 and not (opts and opts.silent) then
    vim.notify("Multiple Molten kernels are active. Re-run <leader>mi and choose a kernel.", vim.log.levels.ERROR)
  end

  return nil
end

local function define_cell(start_line, end_line, opts)
  opts = opts or {}

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local kernel = active_kernel(opts)
  local ok, err
  if kernel then
    ok, err = pcall(vim.fn.MoltenDefineCell, start_line, end_line, kernel)
  else
    ok, err = pcall(vim.fn.MoltenDefineCell, start_line, end_line)
  end

  if not ok then
    if not opts.silent then
      vim.notify("MoltenDefineCell failed: " .. tostring(err), vim.log.levels.ERROR)
    end
    return false
  end

  -- Molten commands operate on the active cell under the cursor. If the cursor
  -- is on a # %% marker/comment, move it into the code cell we just defined.
  if opts.move_cursor ~= false then
    local current = vim.api.nvim_win_get_cursor(0)[1]
    if current < start_line or current > end_line then
      vim.api.nvim_win_set_cursor(0, { start_line, 0 })
    end
  end

  return true
end

local function run_active_cell()
  vim.cmd("MoltenReevaluateCell")
end

function M.define_visual_cell()
  return define_cell(vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2])
end

function M.run_visual_cell()
  if M.define_visual_cell() then
    run_active_cell()
  end
end

local function is_percent_marker(line)
  return line:match("^%s*#%s*%%%%") ~= nil
end

local function percent_cell_bounds(marker, last)
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

  return start_line, end_line
end

function M.define_all_percent_cells(opts)
  opts = opts or {}
  local last = vim.fn.line("$")
  local count = 0

  for line = 1, last do
    if is_percent_marker(vim.fn.getline(line)) then
      local start_line, end_line = percent_cell_bounds(line, last)
      if start_line <= end_line and define_cell(start_line, end_line, opts) then
        count = count + 1
      end
    end
  end

  if count > 0 and not opts.silent then
    vim.notify(("Defined %d Molten cells"):format(count), vim.log.levels.INFO)
  end

  return count
end

local function init_with_kernel(kernel)
  M.kernel = kernel
  vim.cmd(("MoltenInit %s"):format(kernel))
  M.define_all_percent_cells()
end

function M.init(kernel)
  if kernel then
    init_with_kernel(kernel)
    return
  end

  local ok, kernels = pcall(vim.fn.MoltenAvailableKernels)
  kernels = ok and kernels or {}

  if #kernels == 1 then
    init_with_kernel(kernels[1])
    return
  end

  vim.ui.select(kernels, { prompt = "Molten kernel" }, function(choice)
    if choice then
      init_with_kernel(choice)
    end
  end)
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

  local start_line, end_line = percent_cell_bounds(marker, last)

  if start_line > end_line then
    vim.notify("No code in this # %% cell", vim.log.levels.WARN)
    return true
  end

  return define_cell(start_line, end_line)
end

function M.define_paragraph_cell()
  if M.define_percent_cell() then
    return true
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

  return define_cell(start_line, end_line)
end

function M.run_cell()
  if M.define_paragraph_cell() then
    run_active_cell()
  end
end

function M.setup_autocmds()
  local group = vim.api.nvim_create_augroup("UserPercentCells", { clear = true })

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    pattern = "*.py",
    callback = function()
      -- Keep Molten extmark cells aligned with # %% markers after edits/saves.
      -- If Molten is not initialized for this buffer, this silently does nothing.
      M.define_all_percent_cells({ silent = true, move_cursor = false })
    end,
  })
end

return M
