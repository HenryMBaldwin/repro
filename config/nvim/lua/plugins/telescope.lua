return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function() return vim.fn.executable 'make' == 1 end,
    },
    'nvim-telescope/telescope-ui-select.nvim',
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('telescope').setup {
      extensions = {
        ['ui-select'] = { require('telescope.themes').get_dropdown() },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local builtin = require 'telescope.builtin'
    local map = vim.keymap.set

    map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    map('n', '<leader>sf', function() builtin.find_files { hidden = true } end, { desc = '[S]earch [F]iles' })
    map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    map({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    map('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
    map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    map('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })

    map(
      'n',
      '<leader>/',
      function() builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false }) end,
      { desc = '[/] Fuzzily search in current buffer' }
    )

    map(
      'n',
      '<leader>s/',
      function() builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' } end,
      { desc = '[S]earch [/] in Open Files' }
    )

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
      callback = function(event)
        local bmap = function(keys, func, desc) vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc }) end

        bmap('grr', builtin.lsp_references, '[G]oto [R]eferences')
        bmap('gri', builtin.lsp_implementations, '[G]oto [I]mplementation')
        bmap('grd', builtin.lsp_definitions, '[G]oto [D]efinition')
        bmap('grt', builtin.lsp_type_definitions, '[G]oto [T]ype Definition')
        bmap('gO', builtin.lsp_document_symbols, 'Open Document Symbols')
        bmap('gW', builtin.lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
      end,
    })
  end,
}
