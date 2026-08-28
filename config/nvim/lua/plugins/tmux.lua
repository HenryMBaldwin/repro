return {
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
    },
    keys = {
      { '<C-h>', '<cmd>TmuxNavigateLeft<cr>', desc = 'Move focus to the left window' },
      { '<C-j>', '<cmd>TmuxNavigateDown<cr>', desc = 'Move focus to the lower window' },
      { '<C-k>', '<cmd>TmuxNavigateUp<cr>', desc = 'Move focus to the upper window' },
      { '<C-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'Move focus to the right window' },
    },
  },
}
