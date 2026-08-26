return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function() require('conform').format { async = true, lsp_format = 'fallback' } end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
    formatters = {
      prettier = {
        prepend_args = { '--prose-wrap', 'always' },
      },
      clang_format = {
        -- Honour a project's .clang-format; otherwise LLVM style at 4 spaces
        args = function(_, ctx)
          local found = vim.fs.find({ '.clang-format', '_clang-format' }, { path = ctx.dirname, upward = true })[1]
          return { '--assume-filename', '$FILENAME', '--style=' .. (found and 'file' or '{BasedOnStyle: LLVM, IndentWidth: 4}') }
        end,
      },
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      c = { 'clang_format' },
      cpp = { 'clang_format' },
      rust = { 'rustfmt' },
      markdown = { 'prettier', 'markdownlint' },
      python = { 'ruff_organize_imports', 'ruff_format' },
    },
  },
}
