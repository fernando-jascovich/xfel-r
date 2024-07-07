local env_fname = '/tmp/env_file.Rdata'
local load_env = 'load("' .. env_fname .. '")'
local save_env = 'save.image("' .. env_fname .. '")'
local script_before = {}

local execute_contents = function(contents) 
  local script = vim.fn.tempname()
  vim.fn.writefile(contents, script)
  local result = vim.fn.system({ 'Rscript', script })
  print(result)
end

local get_visual_selected = function()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  return lines
end

local get_input = function(opts)
  local received_contents = {}
  if next(opts.fargs) == nil then
    received_contents = get_visual_selected()
  else
    received_contents = opts.fargs
  end
  return received_contents
end

local append_tables = function(target, to_append)
  for _, x in ipairs(to_append) do
    table.insert(target, x)
  end
end

local Rexecute = function(opts)
  local received_contents = get_input(opts)
  if next(received_contents) == nil then
    print("No content, nothing to do.")
    return
  end

  local contents = { load_env }
  append_tables(contents, script_before)
  append_tables(contents, received_contents)
  table.insert(contents, save_env)
  execute_contents(contents)
end

local RclearBefore = function() 
  script_before = {} 
end

local Rclear = function() 
  vim.fn.system({ 'Rscript', '-e', save_env })
  RclearBefore()
end

local Rmarkdown = function() 
  local fname = vim.fn.expand("%")
  local contents = {
    'library(rmarkdown)',
    'rmarkdown::render("' .. fname .. '")'
  }
  execute_contents(contents)
end

local Radd = function(opts)
  local received_contents = get_input(opts)
  if next(received_contents) == nil then
    print("No content, nothing to do.")
    return
  end
  append_tables(script_before, received_contents)
  print(table.concat(script_before, "\n"))
end

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = { "*.R", "*.Rmd" },
  callback = function()
    vim.api.nvim_create_user_command(
      'Rexecute', 
      Rexecute, 
      { range = true, nargs = "*" }
    )
    vim.api.nvim_create_user_command('Rclear', Rclear, {})
    vim.api.nvim_create_user_command('RclearBefore', RclearBefore, {})
    vim.api.nvim_create_user_command(
      'Radd', 
      Radd, 
      { range = true, nargs = "*" }
    )
  end
})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = { "*.Rmd" },
  callback = function()
    vim.api.nvim_create_user_command('Rmarkdown', Rmarkdown, {})
  end
})
