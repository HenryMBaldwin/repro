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
    init = function()
      vim.g.tmux_navigator_no_wrap = 1
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      if not vim.env.TMUX then
        return
      end

      -- Advertise which directions have another split as a "tmuxnav:LRUD" title for tmux.
      local function advertise()
        local dirs = ''
        for _, d in ipairs { { 'h', 'L' }, { 'l', 'R' }, { 'k', 'U' }, { 'j', 'D' } } do
          if vim.fn.winnr(d[1]) ~= vim.fn.winnr() then
            dirs = dirs .. d[2]
          end
        end
        vim.o.titlestring = 'tmuxnav:' .. dirs
      end

      vim.o.title = true
      vim.o.titleold = vim.fn.hostname()
      advertise()
      local group = vim.api.nvim_create_augroup('tmuxnav', { clear = true })
      vim.api.nvim_create_autocmd({ 'WinEnter', 'WinNew', 'WinResized', 'VimResized', 'VimResume', 'TabEnter' }, {
        group = group,
        callback = advertise,
      })
      vim.api.nvim_create_autocmd('WinClosed', {
        group = group,
        callback = function()
          vim.schedule(advertise)
        end,
      })
      vim.api.nvim_create_autocmd('VimSuspend', {
        group = group,
        callback = function()
          vim.o.titlestring = vim.fn.hostname()
        end,
      })
    end,
  },
}
