-- Leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","
-- Colorscheme, some plugins are picky if it changes after load
vim.cmd('colorscheme vim')

-- Neovim configuration converted from .vimrc
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require("lazy").setup({
  -- Completion engine
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- LSP
  { "neovim/nvim-lspconfig" },

  -- Mason: LSP installer
  { "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  { "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        -- mason-lspconfig uses lspconfig server names here.
        ensure_installed = {
          "ansiblels",
          "bashls",
          "clangd",
          "efm",
          "eslint",
          "glsl_analyzer",
          "gn_language_server",
          "groovyls",
          "jdtls",
          "jsonls",
          "jsonnet_ls",
          "ts_ls",
          "ruff",
          "rust_analyzer",
          "starpls",
          "ty",
        },
        automatic_installation = true,
      })
    end,
  },
  -- mason-tool-installer: auto-install non-LSP tools (linters, formatters)
  { "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "shellcheck",
          "tree-sitter-cli",
        },
      })
    end,
  },

  -- Multiple cursors
  {
     "hansfilipelo/vim-multiple-cursors",
     config = function()
       require("multi-cursors").setup()
     end,
  },
  -- Snacks, many modern neovim plugins depend on this
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      input = {},
      picker = { ui_select = false },
    },
  },

  -- Treesitter for some syntax highlighting where LSPs don't support it
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install { 'gn', 'starlark' }
    end,
  },

  -- Airline
  { "vim-airline/vim-airline" },

  -- Neo-tree
  { "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        sources = {
          "filesystem",
          "buffers",
          "git_status",
          "document_symbols",
        },
      })
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },

  -- FZF
  { "junegunn/fzf", build = "./install --all" },
  {
    "ibhagwan/fzf-lua",
    lazy = false,
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    opts = { ui_select = true },
  },

  -- Rename
  { "danro/rename.vim" },

  -- Jsonnet syntax
  { "google/vim-jsonnet" },

  -- Copilot
  { "github/copilot.vim" },

  -- opencode
  {
    "sudo-tee/opencode.nvim",
    config = function()
      require("opencode").setup({
        preferred_picker = 'fzf', -- 'telescope', 'fzf', 'mini.pick', 'snacks', 'select'
        keymap = {
          editor = {
            ['<C-k>'] = { 'toggle' }, -- Open opencode. Close if opened
            ['<C-q>'] = { 'quick_chat' }, -- Open opencode. Close if opened
          }
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
          file_types = { 'opencode_output' },
        },
        ft = { 'opencode_output' },
      },
      -- Optional, for file mentions and commands completion, pick only one
      'saghen/blink.cmp',
      -- 'hrsh7th/nvim-cmp',

      -- Optional, for file mentions picker, pick only one
      --'folke/snacks.nvim',
      -- 'nvim-telescope/telescope.nvim',
      'ibhagwan/fzf-lua',
      -- 'nvim_mini/mini.nvim',
    },
  },
})

-- LSP/autocomplete
----------------------------------------------------------------------------------
-- nvim-cmp completion setup
local cmp = require('cmp')
local luasnip = require('luasnip')
cmp.setup({
  preselect = cmp.PreselectMode.Item,
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>']     = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.confirm({ select = true })
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { 'i', 's' }),
    ['<S-Tab>']   = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  }),
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('clangd', {
  capabilities = capabilities,
  cmd = { 'clangd', '--background-index', '--clang-tidy' },
  on_init = function(client)
    -- Disable semantic tokens to prevent clangd from incorrectly highlighting
    -- the whole file as a comment when a completion is cancelled.
    -- client.server_capabilities.semanticTokensProvider = nil
  end,
})
vim.lsp.enable('clangd')

-- Alternate file commands (replaces a.vim) using clangd's switch source/header
local function switch_source_header(pre_cmd)
  local params = { uri = vim.uri_from_bufnr(0) }
  vim.lsp.buf_request(0, 'textDocument/switchSourceHeader', params, function(err, uri)
    if err or not uri or uri == '' then
      vim.notify('No alternate file found', vim.log.levels.WARN)
      return
    end
    if pre_cmd then vim.cmd(pre_cmd) end
    vim.cmd('edit ' .. vim.uri_to_fname(uri))
  end)
end

vim.api.nvim_create_user_command('A',  function() switch_source_header() end, {})
vim.api.nvim_create_user_command('AS', function() switch_source_header('split') end, {})
vim.api.nvim_create_user_command('AV', function() switch_source_header('vsplit') end, {})
vim.api.nvim_create_user_command('AT', function() switch_source_header('tabnew') end, {})

-- Auto-create a .venv from requirements.txt using uv.
-- Returns the project root (directory containing requirements.txt) or nil.
local _venv_creating = {}
local function ensure_python_venv(bufnr)
  local req = vim.fs.find('requirements.txt', {
    upward = true,
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
  })[1]
  if not req then return nil end
  local root = vim.fs.dirname(req)
  local venv = root .. '/.venv'

  if vim.uv.fs_stat(venv) then return root end
  if _venv_creating[root] then return root end
  _venv_creating[root] = true

  vim.notify('Creating venv in ' .. root .. ' …', vim.log.levels.INFO)
  vim.system(
    { 'uv', 'venv', '--quiet', venv },
    { text = true },
    function(venv_result)
      if venv_result.code ~= 0 then
        vim.schedule(function()
          vim.notify('uv venv failed: ' .. (venv_result.stderr or ''), vim.log.levels.ERROR)
          _venv_creating[root] = nil
        end)
        return
      end
      vim.system(
        { 'uv', 'pip', 'install', '--quiet', '-r', req },
        { text = true, env = { VIRTUAL_ENV = venv } },
        function(pip_result)
          _venv_creating[root] = nil
          vim.schedule(function()
            if pip_result.code ~= 0 then
              vim.notify('uv pip install failed: ' .. (pip_result.stderr or ''), vim.log.levels.ERROR)
            else
              vim.notify('venv ready: ' .. root, vim.log.levels.INFO)
              -- Restart Python LSPs so they pick up the new venv
              for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                if client.name == 'ty' or client.name == 'ruff' then
                  vim.cmd('LspRestart ' .. client.name)
                end
              end
            end
          end)
        end
      )
    end
  )
  return root
end

local function python_root_dir(bufnr)
  local req = vim.fs.find('requirements.txt', {
    upward = true,
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
  })[1]
  if req then return vim.fs.dirname(req) end
  -- Fall back to common project markers
  return vim.fs.root(bufnr, { '.git', 'pyproject.toml', 'setup.py', 'setup.cfg' })
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function(ev) ensure_python_venv(ev.buf) end,
})

vim.lsp.config('ty', {
  capabilities = capabilities,
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_dir = function(bufnr) return python_root_dir(bufnr) end,
})
vim.lsp.enable('ty')

vim.lsp.config('jdtls', {
  capabilities = capabilities,
  cmd = { 'jdtls' },
  filetypes = { 'java' },
})
vim.lsp.enable('jdtls')

vim.lsp.config('bashls', {
  capabilities = capabilities,
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'bash', 'zsh' },
})
vim.lsp.enable('bashls')

vim.lsp.config('groovyls', {
  capabilities = capabilities,
  --cmd = { 'java', '-jar', vim.fn.expand('~/.local/share/groovy-language-server/groovy-language-server-all.jar') },
  filetypes = { 'groovy' },
})
vim.lsp.enable('groovyls')

vim.lsp.config('glsl_analyzer', {
  capabilities = capabilities,
  cmd = { 'glsl_analyzer' },
  filetypes = { 'glsl', 'vert', 'frag', 'geom', 'comp', 'tesc', 'tese' },
})
vim.lsp.enable('glsl_analyzer')

vim.lsp.config('gn_language_server', {
  capabilities = capabilities,
  cmd = { 'gn-language-server' },
  filetypes = { 'gn' },
})
vim.lsp.enable('gn_language_server')

vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
})
vim.lsp.enable('ts_ls')

vim.lsp.config('rust_analyzer', {
  capabilities = capabilities,
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  settings = {
    ['rust-analyzer'] = {
      check = { command = 'clippy' },
    },
  },
})
vim.lsp.enable('rust_analyzer')

vim.lsp.config('ruff', {
  capabilities = capabilities,
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_dir = function(bufnr) return python_root_dir(bufnr) end,
  settings = {
    lineLength = 80,
    lint = {
      ignore = { "E111", "E114" },
    },
  },
  on_attach = function(client)
    -- Disable hover in favor of ty
    client.server_capabilities.hoverProvider = false
  end,
})
vim.lsp.enable('ruff')

vim.lsp.config('eslint', {
  capabilities = capabilities,
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
})
vim.lsp.enable('eslint')

vim.lsp.config('jsonls', {
  capabilities = capabilities,
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
})
vim.lsp.enable('jsonls')

vim.lsp.config('ansiblels', {
  capabilities = capabilities,
  cmd = { 'ansible-language-server', '--stdio' },
  filetypes = { 'yaml.ansible' },
})
vim.lsp.enable('ansiblels')

vim.lsp.config('efm', {
  capabilities = capabilities,
  cmd = { 'efm-langserver' },
  filetypes = { 'markdown', 'jinja' },
  init_options = { documentFormatting = false },
  settings = {
    rootMarkers = { '.git/' },
    languages = {
      markdown = {
        {
          lintCommand = 'markdownlint -s',
          lintStdin = true,
          lintFormats = { 'stdin:%l %m', 'stdin:%l:%c %m' },
        },
      },
      jinja = {
        {
          lintCommand = 'djlint --linter-output-format "{line}:{col}: {code} {message}" --lint -',
          lintStdin = true,
          lintFormats = { '%l:%c: %m' },
        },
      },
    },
  },
})
vim.lsp.enable('efm')

vim.lsp.config('jsonnet_ls', {
  capabilities = capabilities,
  cmd = { 'jsonnet-language-server' },
  filetypes = { 'jsonnet', 'libsonnet' },
})
vim.lsp.enable('jsonnet_ls')

-- StarLSP for starlark (bazel) files
vim.lsp.config('starpls', {
  capabilities = capabilities,
  cmd = { 'starpls' },
  filetypes = { 'star', 'bzl', 'BUILD' },
})
vim.lsp.enable('starpls')

-- Apply cmp-nvim-lsp capabilities to all servers globally.
-- vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })

-- LSP key mappings (set on attach)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd',    vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi',    vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-d>', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<C-f>', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'K',     vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gr',    vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  end,
})
-- Linting
----------------------------------------------------------------------------------
-- LSP diagnostics display, mirros how ALE shows diagnostics
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✗',
      [vim.diagnostic.severity.WARN]  = '⚠',
      [vim.diagnostic.severity.INFO]  = 'ℹ',
      [vim.diagnostic.severity.HINT]  = '➤',
    },
  },
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = true },
})
-- Navigate diagnostics
vim.keymap.set('n', ']d', vim.diagnostic.goto_next,  { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,  { desc = 'Prev diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics to loclist' })

-- Chromium Mojo is not available in nvim-treesitter
local mojom_paths = { 'chromium/src/tools/vim/mojom', 'tools/vim/mojom' }
for _, mojom_path in ipairs(mojom_paths) do
  if vim.fn.isdirectory(mojom_path) == 1 then
    vim.opt.runtimepath:append(mojom_path)
    break
  end
end
vim.filetype.add({ extension = { mojom = 'mojom' } })

-- Basic settings
--------------------------------------------------------
vim.opt.fileencodings = "ucs-bom,utf-8,latin1"

-- Completion options
vim.opt.completeopt = "noinsert,menuone,noinsert,popup"

-- Syntax highlighting
vim.cmd('syntax on')

-- Numbered lines and highlight searches
vim.opt.number = true
vim.opt.hlsearch = true

-- Make Ctrl+C do copy to system clipboard
vim.keymap.set('v', '<C-c>', '"+y')

-- Now CTRL-C doesn't trigger the InsertLeave autocmd in terminal. Map to <ESC>
-- instead.
vim.keymap.set('i', '<C-c>', '<ESC>')

-- No tabs, just spaces
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true

-- Toggle case sensitivity
vim.keymap.set('n', '<F7>', ':set ignorecase! ignorecase?<CR>')
vim.opt.ignorecase = true

-- Mouse integration
vim.opt.mouse = 'nvi'

function ToggleMouse()
  if vim.o.mouse == 'nvi' then
    vim.opt.mouse = ''
  else
    vim.opt.mouse = 'nvi'
  end
end
vim.keymap.set('n', '<C-l>', ':lua ToggleMouse()<CR>')

-- Neo-tree: reveal current file
vim.keymap.set('n', '<C-m>', ':Neotree reveal<CR>')
-- Neo-tree: document_symbols
vim.keymap.set('n', '<C-a>', ':Neotree document_symbols<CR>')

-- Save with git cl format on Ctrl+S
vim.keymap.set('n', '<C-s>', ':w<CR>:!git cl format --upstream HEAD<CR>:e<CR>', { silent = true })

-- Pretty print json
vim.keymap.set('n', '<C-j>', ':%!python3 -m json.tool<CR>')
vim.api.nvim_create_user_command('PrettyJson', '%!python3 -m json.tool', {})

-- Easy comment toggle
vim.keymap.set('n', '<C-Space>', 'gcc', { remap = true })
vim.keymap.set('v', '<C-Space>', 'gc', { remap = true })

-- Yank current file path to clipboard
vim.keymap.set('n', 'ä', ':let @" = expand("%")<CR>')

-- Python/pep8 settings to not have 2 spaces as default for python
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end
})

vim.g.pyindent_continue = '&sw'
vim.g.pyindent_open_paren = '&sw'

-- If file changed on disk, reload it
vim.opt.autoread = true

-- Remove trailing whitespace from files on save
local blacklist = { 'mkd', 'md', 'cc', 'h', 'hpp', 'cpp', 'c' }
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    local contains = false
    for _, v in ipairs(blacklist) do
      if ft == v then
        contains = true
        break
      end
    end
    if not contains then
      vim.cmd([[%s/\s\+$//e]])
    end
  end
})

-- LaTeX settings
vim.g.tex_flavor = 'latex'
vim.opt.grepprg = 'grep -nH $*'
vim.g.Tex_Folding = 0
vim.opt.iskeyword:append(':')

-- FZF mappings
vim.keymap.set({'n', 'i'}, '<C-p>', '<Cmd>FzfLua global<CR>')
vim.keymap.set({'n', 'i', 'v'}, '<C-g>', '<Cmd>FzfLua live_grep<CR>')
vim.keymap.set({'n', 'i', 'v'}, '<C-h>', '<Cmd>FzfLua history<CR>')
vim.keymap.set({'n', 'i', 'v'}, '<C-t>', '<Cmd>FzfLua tabs<CR>')
vim.keymap.set({'n', 'i', 'v'}, '<C-b>', '<Cmd>FzfLua lsp_workspace_symbols<CR>')

-- Syntax highlighting for specific file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gn', 'starlark' },
  callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = { "*.fp", "*.vp", "*.gp", "*.sp", "*.hlsl" },
  callback = function()
    vim.bo.filetype = 'glsl'
    vim.bo.syntax = 'glsl'
  end
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = { "*.fx", "*.mat" },
  callback = function()
    vim.bo.syntax = 'xml'
  end
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.qss",
  callback = function()
    vim.bo.syntax = 'css'
  end
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.omi",
  callback = function()
    vim.bo.syntax = 'cpp'
  end
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "Jenkinsfile.*",
  callback = function()
    vim.bo.filetype = 'groovy'
  end
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.jsonnet",
  callback = function()
    vim.bo.filetype = 'jsonnet'
  end
})

-- Autoread buffers changed
vim.api.nvim_create_autocmd("FocusGained", {
  pattern = "*",
  command = "checktime"
})

-- Disable folding in markdown
vim.g.vim_markdown_folding_disabled = 1

-- TMUX style splits
vim.keymap.set('n', '<C-b>c', ':tabnew +terminal<CR>')
vim.keymap.set('t', '<C-b>c', '<C-\\><C-n>:tabnew +terminal<CR>')

vim.keymap.set('n', '<C-b>"', ':new +terminal<CR>')
vim.keymap.set('t', '<C-b>"', '<C-\\><C-n>:new +terminal<CR>')

vim.keymap.set('n', '<C-b>%', ':vnew +terminal<CR>')
vim.keymap.set('t', '<C-b>%', '<C-\\><C-n>:vnew +terminal<CR>')

-- Remap Esc to close a terminal in neovim
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Neovim terminal settings
vim.api.nvim_create_augroup("neovim_terminal", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  group = "neovim_terminal",
  pattern = "*",
  command = "startinsert"
})
vim.api.nvim_create_autocmd("TermOpen", {
  group = "neovim_terminal",
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end
})

-- Use nvr if giting inside of neovim
vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "gitrebase", "gitconfig" },
  callback = function()
    vim.bo.bufhidden = 'delete'
  end
})

-- Airline configuration
vim.g.airline_section_z = '%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v/%03{col("$")-1}'

-- Copilot
vim.keymap.set('i', '<C-K>', 'copilot#Accept("\\<CR>")', { silent = true, expr = true, replace_keycodes = false })
vim.g.copilot_no_tab_map = true
