vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.signcolumn = 'yes'
vim.o.showmode = false
vim.o.mouse = 'a'
vim.o.confirm = true
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.breakindent = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = 'split'

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Allow a project-root .nvim.lua for project specific settings
vim.o.exrc = true

-- Scheduled after UiEnter because it can increase startup time
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.filetype.add { extension = { svx = 'markdown' } }

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  virtual_text = true,
  virtual_lines = false,
  jump = { float = true },
}
