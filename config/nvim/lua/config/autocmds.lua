vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Spell check prose filetypes',
  group = vim.api.nvim_create_augroup('prose-spell', { clear = true }),
  pattern = { 'markdown', 'text', 'gitcommit', 'svx' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { 'en' }
  end,
})
