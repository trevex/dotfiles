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


-- which-key.nvim
vim.o.timeout = true
vim.o.timeoutlen = 500
require("which-key").setup {}

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
cmd "set number" -- Show line numbers
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
local get_hex = require('cokeline.hlgroups').get_hl_attr

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

  sidebar = {
    filetype = {'NvimTree', 'neo-tree'},
    components = {
      {
        text = function(buf)
          return buf.filetype
        end,
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
        bold = true,
      },
    }
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
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
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

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "gopls", "terraformls", "tsserver", "svelte" }
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }
end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_command [[augroup Format]]
      vim.api.nvim_command [[autocmd! * <buffer>]]
      vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
      vim.api.nvim_command [[augroup END]]
    end
  end,
})


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
local header = {
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
local dashboard = require('dashboard').setup {
  theme = "hyper",
  hide = {
    statusline = false,
  },
  config = {
    header = header,
    shortcut = {
      { desc = " Find File", group = 'DashboardShortCut', key = 'f', action = 'Telescope find_files' },
      { desc = " Find Word", group = 'DashboardShortCut', key = 'g', action = 'Telescope live_grep' },
    },
    week_header = { enable = false },
    packages = { enable = false },
    footer = {'', 'type  :help<Enter>  or  <F1>  for on-line help'}
  },
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
