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

local Rexecute = function(opts)
  local contents = { load_env }
  for _, added in ipairs(script_before) do
    table.insert(contents, added)
  end
  table.insert(contents, opts.fargs[1])
  table.insert(contents, save_env)
  execute_contents(contents)
end

local Rclear = function() 
  vim.fn.system({ 'Rscript', '-e', save_env })
  script_before = {} 
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
  table.insert(script_before, opts.fargs[1])
  print(table.concat(script_before, "\n"))
end

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = { "*.R", "*.Rmd" },
  callback = function()
    vim.api.nvim_create_user_command(
      'Rexecute', 
      Rexecute, { nargs = 1 }
    )
    vim.api.nvim_create_user_command('Rclear', Rclear, {})
    vim.api.nvim_create_user_command('Radd', Radd, { nargs = 1 })
  end
})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = { "*.Rmd" },
  callback = function()
    vim.api.nvim_create_user_command('Rmarkdown', Rmarkdown, {})
  end
})
