local get_visual_selected = function()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  return lines
end

local buffer_number = -1

local util = {}

util.append_tables = function(target, to_append)
  for _, x in ipairs(to_append) do
    table.insert(target, x)
  end
end

util.get_input = function(opts)
  local received_contents = {}
  if next(opts.fargs) == nil then
    received_contents = get_visual_selected()
  else
    received_contents = opts.fargs
  end
  return received_contents
end

util.get_buffer = function()
  local buffer_visible = vim.api.nvim_call_function(
    "bufwinnr", 
    { buffer_number }
  ) ~= -1

  if buffer_number == -1 or not buffer_visible then
    vim.api.nvim_command("botright split R")
    buffer_number = vim.api.nvim_get_current_buf()
    vim.opt_local.readonly = true
    vim.api.nvim_buf_set_keymap(
      buffer_number,
      'n', 
      'q',
      ":q<cr>", 
      { noremap = true }
    )
  end

  return buffer_number
end

return util
