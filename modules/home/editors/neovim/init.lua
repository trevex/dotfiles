local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


g.mapleader = ","


-- Gitsigns
-- require "gitsigns".setup {}


-- Treesitter
require "nvim-treesitter.configs".setup {
  highlight = {
    enable = true,
    disable = { "yaml" },
  },
}


-- Quick-scope
g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}
cmd [[
  augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
  augroup END
]]


-- Better-whitespace
cmd [[
  let g:better_whitespace_filetypes_blacklist = ['dashboard', 'diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'markdown', 'fugitive']
]]
g.better_whitespace_enabled = 1
g.strip_whitespace_on_save = 1


-- Setup the colorscheme
opt.termguicolors = true
opt.background = "dark"
cmd "colorscheme gruvbox"
g.gruvbox_italic = 1
g.gruvbox_contrast_dark = "medium"


cmd "if has('mouse') | set mouse=a | endif"
cmd "if has('persistent_undo') | set undofile | set undodir=~/.local/share/nvim-undo | endif"
cmd "set shada='100,<500,/50,:100,@100,s10,h,c,n$HOME/.local/nvim/shada"
opt.number = true -- Show line numbers
opt.hidden = true -- If hidden is not set, TextEdit might fail
opt.updatetime = 300 -- Smaller updatetime for CursorHold and CursorHoldI
opt.signcolumn = "yes"
opt.splitright = true
opt.splitbelow = true
opt.encoding = "utf-8"
opt.ruler = true
opt.colorcolumn = "80"
opt.autoread = true
opt.autowrite = true
-- Tab stops
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.expandtab = true


-- indent line
g.indentLine_enabled = 1
g.indent_blankline_char = "│"
g.indent_blankline_filetype_exclude = {"help", "terminal", "dashboard"}
g.indent_blankline_buftype_exclude = {"terminal"}
g.indent_blankline_show_trailing_blankline_indent = false
g.indent_blankline_show_first_indent_level = false


-- Easier split navigation
map("n", "<C-J>", "<C-W><C-J>", {noremap=true})
map("n", "<C-K>", "<C-W><C-K>", {noremap=true})
map("n", "<C-L>", "<C-W><C-L>", {noremap=true})
map("n", "<C-H>", "<C-W><C-H>", {noremap=true})

-- Additional keybindings
map("n", "<C-x>", "<Plug>(cokeline-focus-next)", {noremap=true})
map("n", "<C-z>", "<Plug>(cokeline-focus-prev)", {noremap=true})
map("n", "<leader>w", ":w!<cr>")
map("", "<Up>", "gk")
map("", "<Down>", "gj")
map("", "k", "gk")
map("", "j", "gj")
map("i", "jk", "<ESC>")
map("i", "<leader><leader>", "<C-X><C-O>")
map("", "<Leader>c", ":ccl <bar> lcl<CR>", {noremap=true})
map("n", "<leader>d", "\"_d", {noremap=true})
map("x", "<leader>d", "\"_d", {noremap=true})
map("v", "<leader>y", "\"+y", {noremap=true})
map("n", "<leader>Y", "\"+yg_", {noremap=true})
map("n", "<leader>y", "\"+y", {noremap=true})
map("n", "<leader>yy", "\"+yy", {noremap=true})
map("n", "<leader>p", "\"+p", {noremap=true})
map("n", "<leader>P", "\"+P", {noremap=true})
map("v", "<leader>p", "\"+p", {noremap=true})
map("v", "<leader>P", "\"+P", {noremap=true})
-- Symbols outline
map("n", "<C-S>", ":SymbolsOutline<CR>", {noremap=true})


-- Lualine with icons
require "nvim-web-devicons".setup {
  default = true;
}
require "lualine".setup {
  options = {
    icons_enabled = true,
    theme = "gruvbox",
    component_separators = {"｜", "｜"},
    section_separators = {"", "" },
  },
  sections = {
    lualine_a = {{'mode', upper = true}},
    lualine_b = {{'branch', icon = ''}, 'diff'},
    lualine_c = {{'filename', file_status = true, full_path = true}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}


-- nvim-cokeline
local get_hex = require('cokeline/utils').get_hex

require('cokeline').setup({
  default_hl = {
    fg = function(buffer)
      return
        buffer.is_focused
        and get_hex('ColorColumn', 'bg')
         or get_hex('Normal', 'fg')
    end,
    bg = function(buffer)
      return
        buffer.is_focused
        and get_hex('Normal', 'fg')
         or get_hex('ColorColumn', 'bg')
    end,
  },

  components = {
    {
      text = function(buffer) return ' ' .. buffer.devicon.icon end,
      fg = function(buffer) return buffer.devicon.color end,
    },
    {
      text = function(buffer) return buffer.unique_prefix end,
      fg = get_hex('Comment', 'fg'),
      style = 'italic',
    },
    {
      text = function(buffer) return buffer.filename .. ' ' end,
    },
    {
      text = '',
      delete_buffer_on_left_click = true,
    },
    {
      text = ' ',
    }
  },
})


-- nvim-tree-lua
g.nvim_tree_side = "left"
g.nvim_tree_width = 25
g.nvim_tree_auto_ignore_ft = {"dashboard"} -- don't open tree on specific fiypes.
g.nvim_tree_allow_resize = 1

map("n", "<C-T>", ":NvimTreeToggle<CR>", {noremap=true})
map("n", "<leader>r", ":NvimTreeRefresh<CR>", {noremap=true})
map("n", "<leader>n", ":NvimTreeFindFile<CR>", {noremap=true})

require'nvim-tree'.setup {
  disable_netrw = true,
  hijack_netrw = false,
  open_on_tab = false,
  hijack_directories = {
    -- enable the feature
    enable = true,
    -- allow to open the tree if it was previously closed
    auto_open = true,
  },
  update_cwd = true,
  update_focused_file = {
    enable = true,
  },
  filters = {
    dotfiles = true,
    custom = {".git", "node_modules", ".cache"},
  },
  git = {
    ignore = true,
  },
  actions = {
    open_file = {
      quit_on_open = false,
    },
  },
  -- renderer = {
  --   highlight_git = true,
  --   highlight_opened_files = "none",
  --   add_trailing = false, -- append a trailing slash to folder names
  --   indent_markers = { enable = true },
  --   icons = {
  --     show = {
  --       git = true,
  --       folder = true,
  --       file = true,
  --     },
  --     glyphs = {
  --       default = "",
  --       symlink = "",
  --       git = {
  --         unstaged = "✗",
  --         staged = "✓",
  --         unmerged = "",
  --         renamed = "➜",
  --         untracked = "★",
  --         deleted = "",
  --         ignored = "◌"
  --       },
  --       folder = {
  --         default = "",
  --         open = "",
  --         empty = "", -- 
  --         empty_open = "",
  --         symlink = "",
  --         symlink_open = ""
  --       },
  --     },
  --   },
  -- },
}


-- Telescope
require('telescope').setup {
  defaults = {
    file_ignore_patterns = { "node%_modules/.*" },
    vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case"
    },
    prompt_prefix = "   ",
    selection_caret = " ",
    entry_prefix = "  ",
    layout_config = {
        horizontal = {
            prompt_position = "bottom",
            preview_width = 0.55,
            results_width = 0.8
        },
        vertical = {
            mirror = false
        },
        width = 0.90,
        height = 0.80,
        preview_cutoff = 120
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('project')

map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", {noremap=true})
map("", "<C-P>", "<cmd>lua require('telescope.builtin').find_files()<cr>", {noremap=true})
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {noremap=true})
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", {noremap=true})
map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", {noremap=true})
map("n", "<leader>fp", "<cmd>lua require('telescope').extensions.project.project{ display_type = 'full' }<cr>", {noremap=true})

-- Tabninefor code completion
local tabnine = require('cmp_tabnine.config')
tabnine:setup({
  max_lines = 1000;
  max_num_results = 20;
  sort = true;
	run_on_every_keystroke = true;
	snippet_placeholder = '..';
})
-- Icons for code completion
local lspkind = require "lspkind"
-- Code completion
local cmp = require "cmp"
cmp.setup({
  formatting = {
    format = lspkind.cmp_format({with_text = true, maxwidth = 50})
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'cmp_tabnine' },
  }, {
    { name = 'path' },
    { name = 'buffer' },
  })
})


-- Gruvbox for cmp
-- cmd [[highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0]]

-- LSP
local lspconfig = require "lspconfig"

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
    vim.api.nvim_command [[augroup END]]
  end
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "gopls", "rnix", "terraformls", "tsserver" }
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }
end


require('rust-tools').setup({
  -- https://github.com/sharksforarms/neovim-rust/blob/master/neovim-init-lsp-cmp-rust-tools.vim
  tools = {
    runnables = {
      use_telescope = true
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },
  server = {
    on_attach = on_attach,
    settings = {
      ["rust-analyzer"] = {
        -- enable clippy on save
        checkOnSave = {
          command = "clippy"
        },
      }
    }
  },
})


-- Dashboard
local dashboard = require('dashboard')

--g.dashboard_default_executive ='telescope'
dashboard.custom_center = {
  {
    icon = " ",
    desc = "Find File",
    shortcut = "leader f f",
    action = "Telescope find_files",
  },
  {
    icon = "  ",
    desc = "Find Word",
    shortcut = "leader f g",
    action = "Telescope live_grep"
  },
  {
    icon = " ",
    desc = "Projects",
    shortcut = "leader f p",
    action = "Telescope projects"
  },
  {
    icon = "  ",
    desc = "Exit",
    shortcut = "leader e e",
    action = "exit"
  }
}
dashboard.custom_footer = {'type  :help<Enter>  or  <F1>  for on-line help'}
vim.cmd [[
augroup dashboard_au
     autocmd! * <buffer>
     autocmd User dashboardReady let &l:stl = 'Dashboard'
     autocmd User dashboardReady nnoremap <buffer> <leader>ee <cmd>exit<CR>
augroup END
]]

dashboard.custom_header = {
  "⠪⠐⠐⠀⠂⠠⢑⠑⢕⠱⢱⢑⢕⠕⡕⡕⡜⡄⠕⢌⠢⡑⢌⠢⡑⡨⢐⢐⢐⢀⠂⡐⢀⠂⡐⢀⠂⡐⢀",
  "⠂⢀⠁⠈⡀⠁⠂⠠⡀⠑⡀⠊⡘⢘⠌⠌⡘⠸⠱⡱⡱⡸⡐⡕⡌⡢⡑⡰⡐⢔⢀⢂⠐⡀⢂⠐⡀⢂⠐",
  "⠠⠀⠀⠄⠀⠐⠈⠀⠂⠠⠀⠑⠌⠄⡌⡐⡈⠄⠡⠐⠱⢱⢱⢱⢱⢱⡨⡢⡊⡆⢆⡂⡂⢂⠂⢂⠂⡂⠌",
  "⠀⠂⢀⠐⠈⠀⠄⠁⢈⠀⡈⠄⠂⠠⠁⠂⠡⠐⠠⢁⠨⠀⠅⠱⡱⣣⡳⡕⡧⡳⣕⢵⢕⡐⡈⠄⢂⢐⠐",
  "⠁⠠⠀⠠⠐⠀⠂⠈⡀⠄⠠⠐⢈⠀⠡⢈⠠⠁⡐⠠⠐⡈⠌⠨⠠⠡⡑⢕⢕⢝⢜⢕⣗⢵⢐⠨⢐⠠⢈",
  "⠐⠀⠂⠐⠀⢁⠈⠠⠀⠂⡁⢐⠠⠈⠨⠀⠄⠡⠐⠠⠡⢐⠨⢨⠈⠅⠢⡁⠣⡱⡱⡱⢵⢝⢵⠨⢐⠨⠠",
  "⠂⢀⠁⡈⠀⠄⠐⠀⠌⠀⠄⠠⠐⡈⠄⠕⠡⡨⡈⡢⠡⠡⡂⢅⠌⠌⡂⡪⢐⠸⡘⡌⡧⡫⡯⣊⢢⠨⡂",
  "⠐⠀⠄⠠⠈⡀⠈⠄⠈⠄⠌⠂⠅⠂⠅⡑⡡⢂⠌⠢⡑⡡⡊⢆⢕⢑⠌⣎⠢⡕⡸⡘⣜⢜⣝⢮⢪⢪⠢",
  "⠁⡈⢀⠐⠠⠀⠡⠠⠁⡂⠌⡈⠄⡡⠨⡐⡨⡐⡌⡪⡰⡨⡪⡸⣘⢜⠜⡌⡇⣇⢇⢇⢎⢧⡳⣫⢧⣳⡹",
  "⠁⠠⠀⠂⡁⠈⠄⡁⢂⠐⡐⢀⢂⠂⢅⢒⢜⢜⢜⢎⢞⢜⢮⢝⢮⢮⡳⡵⣵⣱⢣⣳⢹⡪⡪⣮⢳⢕⢽",
  "⢁⠐⠈⠠⢀⠁⡂⢐⠐⠐⢐⠐⠠⢑⠡⡊⡆⡇⡇⡏⡗⣝⢎⢗⡳⡵⣝⣝⢮⢮⣳⣳⡳⣝⣝⡜⣜⢜⢕",
  "⠠⠐⠈⡀⠂⡀⢂⠐⢈⠐⠀⠄⠅⠢⡱⡑⡕⣕⢵⢹⢪⢎⢗⢗⡝⡮⡮⡺⣪⡳⡳⣕⢯⡺⡮⡯⣺⡪⡳",
  "⠂⠀⠂⡀⠂⡐⠠⢈⠠⠀⡁⠨⠠⡑⡕⡕⡝⣜⢜⢎⢧⡫⣝⢵⡹⡺⡪⡯⣺⡪⣯⡺⡽⡽⡽⣝⣞⡮⡯",
  "⠂⠁⠠⠀⠂⡐⢀⠂⠄⠂⠠⠨⢐⠨⡪⡪⣪⢪⡪⣳⢱⢕⢧⡳⣝⢭⡫⡯⣺⣺⣺⡪⡯⡯⣯⡺⡮⡯⣯",
  "⠐⠈⠀⡈⠠⠐⢀⠂⠡⠈⠠⢈⢐⠈⡎⡮⡪⡺⡜⡎⣇⢯⢺⢜⢮⡳⣝⢞⢞⢮⣺⡪⡯⡯⡮⡯⣯⣻⡺",
  "⠂⠈⢀⠠⠐⠈⠠⠈⠄⠅⠨⢀⠐⠨⠨⡪⡪⡎⡮⡪⣪⢪⢳⡹⣕⢕⢧⡫⣫⡣⡳⣝⢝⢮⣫⡻⡺⣜⠮",
  "⡀⠁⢀⠀⠄⠈⠄⠡⠈⠌⠨⠠⠈⠌⠐⢌⢪⢪⢪⢪⢪⡪⡣⣣⢳⡹⡪⡺⡸⣪⢫⡪⡳⡕⡧⡫⡎⡎⡎",
  "⡀⠄⠀⠄⠀⠂⠠⠁⠡⠡⠡⠡⠡⠡⡁⡂⠢⠡⠣⡱⢱⢱⢹⢸⢸⢜⢎⢎⢧⢳⢱⡹⡜⡎⡮⡪⡪⠪⡪",
  "⠀⠄⠂⠀⠄⠁⡀⠈⠄⢈⠨⠈⢌⢂⢂⠢⠡⠨⠨⢈⠊⢆⢣⢣⢣⢣⢳⢱⢱⢱⢱⢱⠱⡑⢕⢑⢌⢪⠨",
  "⠠⠀⠀⠂⠀⠁⠀⠂⠐⠀⡀⠁⠐⡀⠅⠊⠌⢌⢌⢐⠨⠠⠑⡈⠪⡊⢎⢪⠢⡣⡑⡕⡱⠡⠣⡑⢔⢱⢩",
}


-- Terraform
g.terraform_align = 0
g.terraform_fmt_on_save = 1

-- Indentation defaults
cmd [[
  autocmd Filetype bash setlocal ts=2 sw=2 expandtab
  autocmd Filetype sh setlocal ts=2 sw=2 expandtab
  autocmd FileType yaml setlocal ts=2 sw=2 expandtab
  autocmd FileType helm setlocal ts=2 sw=2 expandtab
  autocmd FileType nix setlocal ts=2 sw=2 expandtab
  autocmd Filetype gohtmltmpl setlocal ts=2 sw=2 expandtab
  autocmd Filetype proto setlocal ts=2 sw=2 expandtab
  autocmd Filetype lua setlocal ts=2 sw=2 expandtab
  " terragrunt
  au BufRead,BufNewFile *.hcl set filetype=terraform
  " zsh.nix is causing confusion
  au BufRead,BufNewFile *.nix set filetype=nix
  " react support
  autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact
]]
