local util = require('xfel-r.util')

local tempfiles = {}

local clear_tempfile = function(job_id)
  if tempfiles[job_id] then
    vim.fn.delete(tempfiles[job_id])
    tempfiles[job_id] = nil
  end
end

local log = function(contents)
  local buffer = util.get_buffer()
  vim.api.nvim_buf_set_option(buffer, "readonly", false)
  vim.api.nvim_buf_set_lines(buffer, -1, -1, true, contents)
  vim.api.nvim_buf_set_option(buffer, "readonly", true)
  vim.api.nvim_buf_set_option(buffer, "modified", false)

  local window = vim.api.nvim_call_function("bufwinid", { buffer })
  local line_count = vim.api.nvim_buf_line_count(buffer)
  vim.api.nvim_win_set_cursor(window, { line_count, 0 })
end

local on_async_event = function(job_id, data, event)
  if event == 'exit' then
    log({ '----------------------------------------' })
    clear_tempfile(job_id)
    return
  end

  log(data)
end

local execution = {}

execution.execute_async = function(contents)
  local tempfile = vim.fn.tempname() 
  vim.fn.writefile(contents, tempfile)
  
  log({ '----------------------------------------' })
  log(contents)

  local cmd_table = ({ 
    'Rscript', 
    '--save',
    '--restore',
    tempfile
  })
  local cmd = table.concat(cmd_table, ' ')
  local opts = {
    on_stdout = on_async_event,
    on_stderr = on_async_event,
    on_exit = on_async_event,
    stdin = 'pipe'
  }
  local job = vim.fn.jobstart(cmd, opts)
  tempfiles[job] = tempfile
end

execution.clear = function()
  execution.execute_async({ 'rm(list=ls())' })
end

return execution
