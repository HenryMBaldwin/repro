return {
  'catppuccin/nvim',
  priority = 1000,
  config = function()
    require('catppuccin').setup {
      flavour = 'macchiato',
      styles = {
        comments = {},
        conditionals = {},
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        lazy = true,
      },
    }
    vim.cmd.colorscheme 'catppuccin'

    local palette = require('catppuccin.palettes').get_palette 'macchiato'
    vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { bg = palette.red, fg = palette.base, bold = true })
    vim.api.nvim_set_hl(0, 'LazyButtonActive', { fg = palette.red })
    vim.api.nvim_set_hl(0, 'LazyH1', { fg = palette.red })
    vim.api.nvim_set_hl(0, 'LazySpecial', { fg = palette.red })
    vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = palette.red })
  end,
}
