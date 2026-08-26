return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('lint').linters_by_ft = {
      markdown = { 'markdownlint' },
    }

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('lint', { clear = true }),
      -- Skip unmodifiable buffers so LSP markdown popups don't get linted
      callback = function()
        if vim.bo.modifiable then require('lint').try_lint() end
      end,
    })
  end,
}
