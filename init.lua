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

-- Basic settings
vim.opt.compatible = false
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = ""
vim.opt.fileencodings = "ucs-bom,utf-8,latin1"

-- Leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Plugin setup
require("lazy").setup({
  -- A.vim - Alternate files quickly
  { "vim-scripts/a.vim" },

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
        -- 'gn' is excluded — not in Mason's registry (custom server).
        ensure_installed = {
          "clangd",
          "pyright",
          "jdtls",
          "bashls",
          "groovyls",
          "ts_ls",
          "rust_analyzer",
        },
        automatic_installation = true,
      })
    end,
  },

  -- Completion engine
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Multiple cursors
  { "terryma/vim-multiple-cursors" },

  -- GLSL syntax
  { "tikhomirov/vim-glsl" },

  -- Indent guides
  { "nathanaelkane/vim-indent-guides" },

  -- Airline
  { "vim-airline/vim-airline" },

  -- NERDTree
  { "scrooloose/nerdtree" },

  -- Rust support
  { "rust-lang/rust.vim" },

  -- Tabline
  { "mkitt/tabline.vim" },

  -- NERDCommenter
  { "scrooloose/nerdcommenter" },

  -- Case convert
  { "chiedo/vim-case-convert" },

  -- FZF
  { "junegunn/fzf", build = "./install --all", dir = "~/.fzf" },
  { "junegunn/fzf.vim" },
  { "ibhagwan/fzf-lua" },

  -- Tagbar
  { "majutsushi/tagbar" },

  -- Semantic highlight
  { "jaxbot/semantic-highlight.vim" },

  -- Rename
  { "danro/rename.vim" },

  -- Vimproc
  { "Shougo/vimproc.vim", build = "make" },

  -- nvim-yarp
  { "roxma/nvim-yarp" },

  -- Clang format
  { "rhysd/vim-clang-format" },

  -- ALE (Asynchronous Lint Engine)
  { "dense-analysis/ale" },

  -- Jsonnet
  { "google/vim-jsonnet" },

  -- GN (Google build tool)
  { "https://gn.googlesource.com/gn", dir = vim.fn.stdpath("data") .. "/lazy/gn", config = function()
    vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/gn/misc/vim")
  end },

  -- Copilot
  { "github/copilot.vim" },

  -- Plenary (required for CopilotChat)
  { "nvim-lua/plenary.nvim" },

  -- CopilotChat
  { "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    config = function()
      require("CopilotChat").setup({
        model = 'claude-sonnet-4.6',
        window = {
          layout = 'horizontal',
          width = 0.5,
        },
        pattern = 'copilot-*',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.opt_local.conceallevel = 0
        end
      })
    end
  },

  -- Starlark
  { "cappyzawa/starlark.vim" },
})

-- Automatic reloading of init.lua
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "init.lua", "init.vim", ".vimrc" },
  command = "source %"
})

-- CTRL-C doesn't trigger the InsertLeave autocmd. Map to <ESC> instead.
vim.keymap.set('i', '<C-c>', '<ESC>')

-- Completion options
vim.opt.completeopt = "noinsert,menuone,noinsert,popup"

-- Required for operations modifying multiple buffers like rename
vim.opt.hidden = true

-- Make Ctrl+C do copy to system clipboard
vim.keymap.set('v', '<C-c>', '"+y')

-- Syntax highlighting
vim.cmd('syntax on')

-- Numbered lines and highlight searches
vim.opt.number = true
vim.opt.ruler = true
vim.opt.hlsearch = true

-- No tabs, just spaces
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true

-- C/C++ indentation
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.cc", "*.h", "*.hpp", "*.cpp", "*.c" },
  callback = function()
    vim.opt_local.cinoptions = "(0,W4"
  end
})

-- Chromium formatting
vim.keymap.set('n', '<C-S>', ':w<CR>:!git cl format --upstream HEAD~<CR>:e<CR>', { silent = true })

-- Python/pep8 settings
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

-- ALE settings
-- Only run linters explicitly listed below; C/C++/Java use their own tooling.
vim.g.ale_linters_explicit = 1
vim.g.ale_linters = {
  python   = { 'flake8', 'pylint' },
  sh       = { 'shellcheck' },
  bash     = { 'shellcheck' },
  zsh      = { 'shellcheck' },
  ansible  = { 'ansible-lint' },
  markdown = { 'markdownlint' },
  jinja    = { 'djlint' },
  json     = { 'jsonlint' },
  javascript = { 'eslint' },
  typescript = { 'eslint' },
  groovy   = { 'npm-groovy-lint' },
  c        = {},
  cpp      = {},
  java     = {},
}
vim.g.ale_python_flake8_options = '--ignore=E501,E123,W504,W328,E111,E114 --max-line-length=80'
vim.g.ale_python_pylint_options = '--disable=C0301 --max-line-length=80'
vim.g.ale_open_list = 1
vim.g.ale_list_window_size = 5
vim.g.ale_sign_error   = '✗'
vim.g.ale_sign_warning = '⚠'

-- Close the ALE location list when the linted buffer's window is closed
vim.api.nvim_create_autocmd("WinClosed", {
  callback = function(ev)
    local closed_win = tonumber(ev.match)
    -- Identify associated loclist windows synchronously, while the relationship is still intact
    local to_close = {}
    for _, info in ipairs(vim.fn.getwininfo()) do
      if info.loclist == 1 then
        local loc = vim.fn.getloclist(info.winid, { filewinid = 0 })
        if loc.filewinid == closed_win then
          table.insert(to_close, info.winid)
        end
      end
    end
    vim.schedule(function()
      for _, win in ipairs(to_close) do
        if vim.api.nvim_win_is_valid(win) then
          pcall(vim.api.nvim_win_close, win, true)
        end
      end
    end)
  end,
})

-- Toggle case sensitivity
vim.keymap.set('n', '<F7>', ':set ignorecase! ignorecase?<CR>')
vim.opt.ignorecase = true

-- Make backspace work
vim.opt.backspace = '2'

-- Mouse integration
vim.opt.mouse = 'nvi'

function ToggleMouse()
  if vim.o.mouse == 'nvi' then
    vim.opt.mouse = ''
  else
    vim.opt.mouse = 'nvi'
  end
end

vim.keymap.set('n', '<C-m>', ':lua ToggleMouse()<CR>')

-- If file changed on disk, reload it
vim.opt.autoread = true

-- Show command
vim.opt.showcmd = true

-- LSP + clangd setup
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

vim.lsp.config('pyright', {
  capabilities = capabilities,
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})
vim.lsp.enable('pyright')

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
  cmd = { 'java', '-jar', vim.fn.expand('~/.local/share/groovy-language-server/groovy-language-server-all.jar') },
  filetypes = { 'groovy' },
})
vim.lsp.enable('groovyls')

vim.lsp.config('gn', {
  capabilities = capabilities,
  cmd = { 'gn-language-server' },
  filetypes = { 'gn' },
})
vim.lsp.enable('gn')

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
      checkOnSave = { command = 'clippy' },
    },
  },
})
vim.lsp.enable('rust_analyzer')

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

-- nvim-cmp completion setup
local cmp = require('cmp')
local luasnip = require('luasnip')
cmp.setup({
  preselect = cmp.PreselectMode.Item,
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),
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

-- Clojure stuff
vim.g.salve_auto_start_repl = 1

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
vim.keymap.set('n', '<C-P>', ':FZF<CR>')
vim.keymap.set('n', '<C-Å>', ':GFiles<CR>')
vim.keymap.set('n', '<C-H>', ':History<CR>')
vim.keymap.set('n', '<C-T>', ':Tags<CR>')

-- Force removal of regular CtrlP
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    vim.keymap.set('n', '<C-P>', ':FZF<CR>')
    vim.keymap.set('n', '<C-Å>', ':GFiles<CR>')
  end
})

-- CtrlP delay
vim.g.ctrlp_lazy_update = 150

-- ctags
vim.opt.tags = 'tags;'
vim.keymap.set('n', '<F8>', ':TagbarToggle<CR>')

-- Copy relative path
vim.api.nvim_create_user_command('CopyRelPath', function()
  vim.fn.setreg('+', vim.fn.expand('%'))
end, {})
vim.keymap.set('n', '<C-g>', ':CopyRelPath<CR>:echo expand("%")<CR>')

-- Syntax highlighting for specific file types
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

-- Pretty print json
vim.keymap.set('n', '<C-j>', ':%!python3 -m json.tool<CR>')
vim.api.nvim_create_user_command('PrettyJson', '%!python3 -m json.tool', {})

-- Gitgutter max
vim.g.gitgutter_max_signs = 1000

-- Easy comment toggle
vim.keymap.set('n', '<C-Space>', 'v<leader>c<Space>', { remap = true })
vim.keymap.set('v', '<C-Space>', '<leader>c<Space>', { remap = true })

-- Yank current file path to clipboard
vim.keymap.set('n', 'ä', ':let @" = expand("%")<CR>')

-- CSCOPE settings
if vim.fn.has("cscope") == 1 then
  vim.opt.cscopeverbose = false
  vim.opt.cscopetag = true
  vim.opt.csto = 0

  -- Add cscope database
  if vim.fn.filereadable("cscope.out") == 1 then
    vim.cmd('cs add cscope.out')
  elseif vim.env.CSCOPE_DB and vim.env.CSCOPE_DB ~= "" then
    vim.cmd('cs add ' .. vim.env.CSCOPE_DB)
  end

  vim.opt.cscopeverbose = true

  -- Cscope key mappings
  vim.keymap.set('n', '<C-_>s', ':cs find s <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-_>g', ':cs find g <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-_>c', ':cs find c <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-_>t', ':cs find t <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-_>e', ':cs find e <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-_>f', ':cs find f <C-R>=expand("<cfile>")<CR><CR>')
  vim.keymap.set('n', '<C-_>i', ':cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>')
  vim.keymap.set('n', '<C-_>d', ':cs find d <C-R>=expand("<cword>")<CR><CR>')

  -- Vertical split versions
  vim.keymap.set('n', '<C-Space>s', ':vert scs find s <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-Space>g', ':vert scs find g <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-Space>c', ':vert scs find c <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-Space>t', ':vert scs find t <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-Space>e', ':vert scs find e <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-Space>f', ':vert scs find f <C-R>=expand("<cfile>")<CR><CR>')
  vim.keymap.set('n', '<C-Space>i', ':vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>')
  vim.keymap.set('n', '<C-Space>d', ':vert scs find d <C-R>=expand("<cword>")<CR><CR>')

  -- Double Ctrl-Space versions
  vim.keymap.set('n', '<C-@><C-@>s', ':scs find s <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-@><C-@>g', ':scs find g <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-@><C-@>c', ':scs find c <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-@><C-@>t', ':scs find t <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-@><C-@>e', ':scs find e <C-R>=expand("<cword>")<CR><CR>')
  vim.keymap.set('n', '<C-@><C-@>f', ':scs find f <C-R>=expand("<cfile>")<CR><CR>')
  vim.keymap.set('n', '<C-@><C-@>i', ':scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>')
  vim.keymap.set('n', '<C-@><C-@>d', ':scs find d <C-R>=expand("<cword>")<CR><CR>')
end

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

-- Colorscheme
vim.cmd('colorscheme vim')

-- Copilot
vim.keymap.set('i', '<C-K>', 'copilot#Accept("\\<CR>")', { silent = true, expr = true, replace_keycodes = false })
vim.g.copilot_no_tab_map = true

-- FZF-lua setup
require('fzf-lua').register_ui_select()

-- CopilotChat mapping
vim.keymap.set('', '<C-k>', ':CopilotChat<CR>')
