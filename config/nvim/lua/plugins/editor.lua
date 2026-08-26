return {
  { 'NMAC427/guess-indent.nvim', opts = {} },

  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },

  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { 'petertriho/nvim-scrollbar', main = 'scrollbar', opts = {} },

  {
    'akinsho/toggleterm.nvim',
    opts = {
      open_mapping = [[<c-\>]],
      direction = 'horizontal',
    },
  },
}
