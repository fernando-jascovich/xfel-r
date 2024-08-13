vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = { "*.R", "*.Rmd" },
  callback = function()
    local userfns = require('xfel-r.userfns')

    vim.api.nvim_create_user_command(
      'Rexecute', 
      userfns.execute, 
      { range = true, nargs = "*" }
    )
    vim.api.nvim_create_user_command('RexecuteAll', userfns.execute_all, {})
    vim.api.nvim_create_user_command('Rclear', userfns.clear, {})
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
    local userfns = require('xfel-r.userfns')
    vim.api.nvim_create_user_command('Rmarkdown', userfns.markdown, {})
    vim.api.nvim_create_user_command('RmarkdownRun', userfns.markdown_run, {})
  end
})
