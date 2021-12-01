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
require "gitsigns".setup {}


-- Treesitter
require "nvim-treesitter.configs".setup {
  ensure_installed = "maintained",
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
g.better_whitespace_enabled = 1
g.strip_whitespace_on_save = 1


-- Setup the colorscheme
opt.termguicolors = true
opt.background = "dark"
cmd "colorscheme gruvbox"
g.gruvbox_italic = 1
g.gruvbox_contrast_dark = "medium"
cmd [[highlight! link CmpItemKindFunction GruvboxAqua]]


cmd "if has('mouse') | set mouse=a | endif"
cmd "if has('persistent_undo') | set undofile | set undodir=~/.local/share/nvim-undo | endif"
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
map("n", "<C-x>", ":bnext<CR>", {noremap=true})
map("n", "<C-z>", ":bprev<CR>", {noremap=true})
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


-- Bufferline
require "bufferline".setup {
  options = {
    offsets = {{filetype = "NvimTree", text = "", padding = 1}},
    buffer_close_icon = "",
    modified_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 14,
    max_prefix_length = 13,
    tab_size = 20,
    show_tab_indicators = true,
    enforce_regular_tabs = false,
    view = "multiwindow",
    show_buffer_close_icons = true,
    show_close_icon = false,
    separator_style = "slant"
  }
}

-- nvim-tree-lua
g.nvim_tree_side = "left"
g.nvim_tree_width = 25
g.nvim_tree_auto_ignore_ft = {"dashboard"} -- don't open tree on specific fiypes.
g.nvim_tree_quit_on_open = 0 -- closes tree when file's opened
g.nvim_tree_indent_markers = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_highlight_opened_files = 0
g.nvim_tree_allow_resize = 1
g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names

g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1
}
g.nvim_tree_icons = {
  default = "",
  symlink = "",
  git = {
    unstaged = "✗",
    staged = "✓",
    unmerged = "",
    renamed = "➜",
    untracked = "★",
    deleted = "",
    ignored = "◌"
  },
  folder = {
    default = "",
    open = "",
    empty = "", -- 
    empty_open = "",
    symlink = "",
    symlink_open = ""
  }
}

map("n", "<C-T>", ":NvimTreeToggle<CR>", {noremap=true})
map("n", "<leader>r", ":NvimTreeRefresh<CR>", {noremap=true})
map("n", "<leader>n", ":NvimTreeFindFile<CR>", {noremap=true})

require'nvim-tree'.setup {
  disable_netrw = true,
  hijack_netrw = false,
  auto_close = true, -- closes tree when it's the last window
  open_on_tab = false,
  update_to_buf_dir   = {
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
}


-- Telescope
require('telescope').setup {
  defaults = {
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
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'cmp_tabnine' },
  }, {
    { name = 'path' },
    { name = 'buffer' },
  })
})


-- go.nvim
require('go').setup()

map("n", "<leader>gf", "<cmd>lua require('go.format').gofmt()<cr>", {noremap=true})
map("n", "<leader>gF", "<cmd>lua require('go.format').gofmt()<cr>", {noremap=true})
-- vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').gofmt() ]], false)
-- vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)




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
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "gopls", "rnix", "terraformls" }
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }
end


-- Dashboard
local g = vim.g
g.dashboard_default_executive ='telescope'
g.dashboard_custom_section = {
    a = {description = {"  Find File                 leader f f"}, command = "Telescope find_files"},
    c = {description = {"  Find Word                 leader f g"}, command = "Telescope live_grep"},
    e = {description = {"  Projects                  leader f p"}, command = "Telescope projects"},
    i = {description = {"  Exit                      leader e e"}, command = "exit"}
}
g.dashboard_custom_footer = {'type  :help<Enter>  or  <F1>  for on-line help'}
vim.cmd [[
augroup dashboard_au
     autocmd! * <buffer>
     autocmd User dashboardReady let &l:stl = 'Dashboard'
     autocmd User dashboardReady nnoremap <buffer> <leader>ee <cmd>exit<CR>
augroup END
]]

g.dashboard_custom_header = {
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
]]
