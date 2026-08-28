local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

map('n', '<leader>ypr', function() vim.fn.setreg('+', vim.fn.expand '%') end, { desc = '[Y]ank [P]ath [R]elative' })
map('n', '<leader>ypa', function() vim.fn.setreg('+', vim.fn.expand '%:p') end, { desc = '[Y]ank [P]ath [A]bsolute' })

map('n', 'gh', vim.diagnostic.open_float, { desc = 'Line diagnostics' })

map('n', ']e', function() vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, count = 1 } end, { desc = 'Next error' })
map('n', '[e', function() vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, count = -1 } end, { desc = 'Previous error' })
map('n', ']w', function() vim.diagnostic.jump { severity = vim.diagnostic.severity.WARN, count = 1 } end, { desc = 'Next warn' })
map('n', '[w', function() vim.diagnostic.jump { severity = vim.diagnostic.severity.WARN, count = -1 } end, { desc = 'Previous warn' })

map('n', '<leader>q', function()
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    vim.cmd.lclose()
  else
    vim.diagnostic.setloclist()
  end
end, { desc = 'Toggle diagnostic location list' })

map('n', '<leader>Q', function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd.cclose()
  else
    vim.diagnostic.setqflist()
  end
end, { desc = 'Toggle diagnostic [Q]uickfix list (all buffers)' })
