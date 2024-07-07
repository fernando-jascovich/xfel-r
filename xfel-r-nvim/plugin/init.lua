local env_fname = '/tmp/env_file.Rdata'
local post = 'save.image("' .. env_fname .. '")'

local Rexecute = function(opts)
  local script = vim.fn.tempname()
  local pre = 'load("' .. env_fname .. '")'
  local contents = { pre, opts.fargs[1], post }
  vim.fn.writefile(contents, script)
  local result = vim.fn.system({ 'Rscript', script })
  print(result)
end

local Rclear = function() 
  vim.fn.system({ 'Rscript', '-e', post })
end

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = "*.Rmd",
  callback = function()
    vim.api.nvim_create_user_command(
      'Rexecute', 
      Rexecute, 
      { nargs = 1 }
    )
    vim.api.nvim_create_user_command('Rclear', Rclear, {})
  end
})
