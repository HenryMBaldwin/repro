return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = {
      { name = 'Seismic', path = '~/Documents/Obisidian Vault/seismic' },
      { name = 'Personal', path = '~/Documents/Obsidian Vault/personal' },
    },
  },
}
