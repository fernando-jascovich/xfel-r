local execute_contents = function(contents) 
  local script = vim.fn.tempname()
  vim.fn.writefile(contents, script)
  local result = vim.fn.system({ 
    'Rscript', 
    '--save',
    '--restore',
    script 
  })
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
  execute_contents(received_contents)
end

local Rclear = function() 
  vim.fn.system({ 
    'Rscript', 
    '--restore',
    '--save',
    '-e', 
    'rm(list=ls())' 
  })
end

local Rmarkdown = function() 
  local fname = vim.fn.expand("%")
  local contents = {
    'library(rmarkdown)',
    'rmarkdown::render("' .. fname .. '")'
  }
  execute_contents(contents)
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
  end
})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = { "*.Rmd" },
  callback = function()
    vim.api.nvim_create_user_command('Rmarkdown', Rmarkdown, {})
  end
})
