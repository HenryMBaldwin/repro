-- Servers installed from Nix (home/dev.nix); Mason must not manage them
local nix_managed = { pyrefly = true, basedpyright = true, ruff = true }

local servers = {
  rust_analyzer = {
    cmd = { 'rustup', 'run', 'stable', 'rust-analyzer' },
  },
  clangd = {},
  gopls = {},
  marksman = {},
  -- Python: pyrefly owns type diagnostics (matches CI), basedpyright is
  -- navigation/hover/completion only, ruff does lint + format.
  pyrefly = {
    root_markers = { { 'pyrefly.toml' }, { 'pyproject.toml', '.git' } },
    on_attach = function(client) client.server_capabilities.hoverProvider = false end,
  },
  basedpyright = {
    root_markers = { { 'pyrightconfig.json' }, { 'pyproject.toml', '.git' } },
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = 'off',
          inlayHints = {
            variableTypes = true,
            functionReturnTypes = true,
            callArgumentNames = true,
            genericTypes = false,
          },
        },
      },
    },
  },
  ruff = {
    root_markers = { { 'ruff.toml', '.ruff.toml' }, { 'pyproject.toml', '.git' } },
    on_attach = function(client) client.server_capabilities.hoverProvider = false end,
  },
}

local extra_tools = {
  'lua_ls',
  'stylua',
  'markdownlint',
  'clang-format',
  'prettier',
}

local function on_attach(event)
  local map = function(keys, func, desc, mode) vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }) end

  map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
  map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
  map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if not client then return end

  if client:supports_method('textDocument/documentHighlight', event.buf) then
    local group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = event.buf,
      group = group,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = event.buf,
      group = group,
      callback = vim.lsp.buf.clear_references,
    })
    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
      callback = function(detach)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = detach.buf }
      end,
    })
  end

  if client:supports_method('textDocument/inlayHint', event.buf) then
    map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
  end
end

-- Settings recommended by `:help lspconfig-lua_ls`
local lua_ls = {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
      workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file('', true) },
    })
  end,
  settings = { Lua = {} },
}

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    { 'mason-org/mason-lspconfig.nvim', opts = {} },
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = on_attach,
    })

    local ensure_installed = vim.tbl_filter(function(name) return not nix_managed[name] end, vim.tbl_keys(servers))
    vim.list_extend(ensure_installed, extra_tools)
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    local capabilities = require('blink.cmp').get_lsp_capabilities()
    for name, server in pairs(servers) do
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end

    vim.lsp.config('lua_ls', lua_ls)
    vim.lsp.enable 'lua_ls'
  end,
}
