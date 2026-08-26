local filetypes = {
  'bash',
  'c',
  'cpp',
  'css',
  'diff',
  'html',
  'javascript',
  'just',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'rust',
  'solidity',
  'sql',
  'svelte',
  'typescript',
  'vim',
  'vimdoc',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter').install(filetypes)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function() vim.treesitter.start() end,
      })
    end,
  },

  { 'nvim-treesitter/nvim-treesitter-context' },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
          },
        },
      },
    },
  },

  { 'HiPhish/rainbow-delimiters.nvim' },
}
