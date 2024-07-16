local util = require('xfel-r.util')
local execution = require('xfel-r.execution')

local Rexecute = function(opts)
  local received_contents = util.get_input(opts)
  if next(received_contents) == nil then
    print("No content, nothing to do.")
    return
  end
  execution.execute_async(received_contents)
end

local RexecuteAll = function(opts)
  local contents = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  execution.execute_async(contents)
end

local Rclear = function() 
  execution.clear()
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
    vim.api.nvim_create_user_command('RexecuteAll', RexecuteAll, {})
    vim.api.nvim_create_user_command('Rclear', Rclear, {})
    vim.api.nvim_set_keymap(
      'n', 
      '<leader>R',
      "V:'<,'>Rexecute<cr>", 
      { noremap = true }
    )
  end
})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = { "*.Rmd" },
  callback = function()
    vim.api.nvim_create_user_command('Rmarkdown', Rmarkdown, {})
  end
})
