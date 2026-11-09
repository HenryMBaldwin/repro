local function default_branch()
  local ref = vim.fn.systemlist('git symbolic-ref --quiet --short refs/remotes/origin/HEAD')[1]
  if vim.v.shell_error == 0 and ref then
    return ref
  end
  for _, name in ipairs { 'origin/main', 'origin/master', 'main', 'master' } do
    vim.fn.system('git rev-parse --verify --quiet ' .. name)
    if vim.v.shell_error == 0 then
      return name
    end
  end
  return 'HEAD'
end

local function pr_diff()
  vim.cmd('DiffviewOpen ' .. default_branch() .. '...HEAD --imply-local')
end

local function pr_history()
  vim.cmd('DiffviewFileHistory --range=' .. default_branch() .. '...HEAD')
end

return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  keys = {
    { '<leader>gp', pr_diff, desc = 'Git [P]R diff against default branch' },
    { '<leader>gP', pr_history, desc = 'Git [P]R commit history' },
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Git [D]iff working tree' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Git file [H]istory' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Git branch [H]istory' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Git diff [Q]uit' },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = { layout = 'diff2_horizontal', winbar_info = true },
      merge_tool = { layout = 'diff3_mixed' },
      file_history = { winbar_info = true },
    },
    file_panel = { win_config = { width = 36 } },
    hooks = {
      view_post_layout = function(view)
        vim.schedule(function()
          local layout = view.cur_layout
          if layout and layout:is_valid() then layout:get_main_win():focus() end
        end)
      end,
    },
    keymaps = {
      view = { { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } } },
      file_panel = { { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } } },
      file_history_panel = { { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } } },
    },
  },
}
