local util = require('xfel-r.util')
local execution = require('xfel-r.execution')
local userfns = {}

userfns.execute = function(opts)
  local received_contents = util.get_input(opts)
  if next(received_contents) == nil then
    print("No content, nothing to do.")
    return
  end
  execution.execute_async(received_contents)
end

userfns.execute_all = function(opts)
  local contents = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  execution.execute_async(contents)
end

userfns.clear = function() 
  execution.clear()
end

userfns.add_library = function(opts)
  execution.add_library(opts.fargs[1])
end

userfns.markdown = function() 
  local fname = vim.fn.expand("%")
  local contents = {
    'library(rmarkdown)',
    'rmarkdown::render("' .. fname .. '")'
  }
  execution.execute_async(contents)
end

return userfns
