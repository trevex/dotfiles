{ config, pkgs, ... }:
{
  imports = [ <home-manager/nix-darwin> ];

  # TODO: yabai, skhd

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    ripgrep
  ];

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      dejavu_fonts
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Use /etc/profiles instead of $HOME/.nix-profile
  home-manager.useUserPackages = true;
  # Use global `pkgs` to save an extra Nixpkgs evaluation, adds consistency
  home-manager.useGlobalPkgs = true;

  home-manager.users.vossni = { pkgs, ... }: {
    home.packages = with pkgs; [
      httpie
      kubectl
      krew
      kubernetes-helm
      google-cloud-sdk
      # language servers
      gopls
      terraform-ls
      rnix-lsp
    ];

    # TODO: setup git and aliases
    # TODO: import gpg public keys?

    home.sessionVariables = {
      TF_PLUGIN_CACHE_DIR = "$HOME/.terraform.d/plugin-cache";
    };

    programs.go = {
      enable = true;
      goPath = "Development/go";
      goBin = "Development/go/bin";
    };

    programs.alacritty = {
      enable = true;
      settings = { # TODO: Move to using yaml directly after all...
        window = {
          dimensions = { columns = 0; lines = 0; };
          padding = { x = 5; y = 5; };
          dynamic_padding = false;
          decorations = "none";
          startup_mode = "Windowed";
        };

        scrolling = { history = 10000; multiplier = 3; auto_scroll = false; };
        tabspaces = 4;
        draw_bold_text_with_bright_colors = true;

        font = {
          normal = { family = "FiraCode Nerd Font Mono"; style = "Light"; };
          bold = { family = "FiraCode Nerd Font Mono"; style = "Medium"; };
          italic = { family = "FiraCode Nerd Font Mono"; style = "Italic"; };
          size = 14.0;
          offset = { x = 0; y = 0; };
          glyph_offset = { x = 0; y = 0; };
          # OS X only: use thin stroke font rendering. Thin strokes are suitable
          # for retina displays, but for non-retina you probably want this set to
          # false.
          use_thin_strokes = true;
        };

        # Gruvbox
        colors = {
          primary = {
            # hard contrast background - "#1d2021"
            background = "#282828";
            # soft contrast background - "#32302f"
            foreground = "#ebdbb2";
            bright_foreground = "#fbf1c7";
            dim_foreground = "#a89984";
          };
          cursor = {
            text = "CellBackground";
            cursor = "CellForeground";
          };
          vi_mode_cursor = {
            text = "CellBackground";
            cursor = "CellForeground";
          };
          # search = {
          #   matches = {
          #     foreground =  "#000000";
          #     background =  "#ffffff";
          #   };
          #   focused_match = {
          #    foreground =  "CellBackground";
          #    background =  "CellForeground";
          #   };
          #   bar = {
          #     background =  "";
          #     foreground =  "";
          #   };
          # };
          # line_indicator = {
          #   foreground =  "None";
          #   background =  "None";
          # };
          selection = {
            text = "CellBackground";
            background = "CellForeground";
          };
          bright = {
            black =    "#928374";
            red =      "#fb4934";
            green =    "#b8bb26";
            yellow =   "#fabd2f";
            blue =     "#83a598";
            magenta =  "#d3869b";
            cyan =     "#8ec07c";
            white =    "#ebdbb2";
          };
          normal = {
            black =    "#282828";
            red =      "#cc241d";
            green =    "#98971a";
            yellow =   "#d79921";
            blue =     "#458588";
            magenta =  "#b16286";
            cyan =     "#689d6a";
            white =    "#a89984";
          };
          dim = {
            black =    "#32302f";
            red =      "#9d0006";
            green =    "#79740e";
            yellow =   "#b57614";
            blue =     "#076678";
            magenta =  "#8f3f71";
            cyan =     "#427b58";
            white =    "#928374";
          };
          # indexed_colors =  []
        };

        visual_bell = {
          animation = "EaseOutExpo";
          duration = 0;
        };

        background_opacity = 1.0;

        mouse_bindings = [{ mouse = "Middle"; action = "PasteSelection"; }];

        mouse = {
          double_click = { threshold = 300; };
          triple_click = { threshold = 300; };
          hide_when_typing = false;
        };

        # hints = {
        #   enabled = [{
        #     regex = ''(mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\u0000-\u001F\u007F-\u009F<>"\s{-}\\^⟨⟩`]+'';
        #     command = "xdg-open";
        #     post_processing = true;
        #     mouse = { enabled = true; mods = "None"; };
        #     binding = { key = "U"; mods = "Control|Shift"; };
        #   }];
        # };

        dynamic_title = true;

        cursor = {
          style = "Block";
          unfocused_hollow = true;
        };
        live_config_reload = true;

        key_bindings = [
          { key = "N";        mods = "Command"; action = "SpawnNewInstance";   }
          { key = "V";        mods = "Command"; action = "Paste";              }
          { key = "C";        mods = "Command"; action = "Copy";               }
          { key = "Paste";                      action = "Paste";              }
          { key = "Copy";                       action = "Copy";               }
          { key = "H";        mods = "Command"; action = "Hide";               }
          { key = "Q";        mods = "Command"; action = "Quit";               }
          { key = "W";        mods = "Command"; action = "Quit";               }
          { key = "Home";  mode = "AppCursor";  chars = "\\x1bOH";             }
          { key = "Home";  mode = "~AppCursor"; chars = "\\x1b[H";             }
          { key = "End";   mode = "AppCursor";  chars = "\\x1bOF";             }
          { key = "End";   mode = "~AppCursor"; chars = "\\x1b[F";             }
          { key = "Key0";     mods = "Command"; action = "ResetFontSize";      }
          { key = "Equals";   mods = "Command"; action = "IncreaseFontSize";   }
          { key = "Minus";    mods = "Command"; action = "DecreaseFontSize";   }
          { key = "PageUp";   mods = "Shift";   chars = "\\x1b[5;2~";          }
          { key = "PageUp";   mods = "Control"; chars = "\\x1b[5;5~";          }
          { key = "PageUp";                     chars = "\\x1b[5~";            }
          { key = "PageDown"; mods = "Shift";   chars = "\\x1b[6;2~";          }
          { key = "PageDown"; mods = "Control"; chars = "\\x1b[6;5~";          }
          { key = "PageDown";                   chars = "\\x1b[6~";            }
          { key = "Tab";      mods = "Shift";   chars = "\\x1b[Z";             }
          { key = "Back";                       chars = "\\x7f";               }
          { key = "Back";     mods = "Alt";     chars = "\\x1b\\x7f";          }
          { key = "Insert";                     chars = "\\x1b[2~";            }
          { key = "Delete";                     chars = "\\x1b[3~";            }
          { key = "Left";     mods = "Shift";   chars = "\\x1b[1;2D";          }
          { key = "Left";     mods = "Control"; chars = "\\x1b[1;5D";          }
          { key = "Left";     mods = "Alt";     chars = "\\x1b[1;3D";          }
          { key = "Left";  mode = "~AppCursor"; chars = "\\x1b[D";             }
          { key = "Left";  mode = "AppCursor";  chars = "\\x1bOD";             }
          { key = "Right";    mods = "Shift";   chars = "\\x1b[1;2C";          }
          { key = "Right";    mods = "Control"; chars = "\\x1b[1;5C";          }
          { key = "Right";    mods = "Alt";     chars = "\\x1b[1;3C";          }
          { key = "Right"; mode = "~AppCursor"; chars = "\\x1b[C";             }
          { key = "Right"; mode = "AppCursor";  chars = "\\x1bOC";             }
          { key = "Up";       mods = "Shift";   chars = "\\x1b[1;2A";          }
          { key = "Up";       mods = "Control"; chars = "\\x1b[1;5A";          }
          { key = "Up";       mods = "Alt";     chars = "\\x1b[1;3A";          }
          { key = "Up";    mode = "~AppCursor"; chars = "\\x1b[A";             }
          { key = "Up";    mode = "AppCursor";  chars = "\\x1bOA";             }
          { key = "Down";     mods = "Shift";   chars = "\\x1b[1;2B";          }
          { key = "Down";     mods = "Control"; chars = "\\x1b[1;5B";          }
          { key = "Down";     mods = "Alt";     chars = "\\x1b[1;3B";          }
          { key = "Down";  mode = "~AppCursor"; chars = "\\x1b[B";             }
          { key = "Down";  mode = "AppCursor";  chars = "\\x1bOB";             }
          { key = "NumpadEnter";                chars = "\\n";                 }
        ];
      };
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-syntax-highlighting"; tags = ["defer:2"]; }
          { name = "plugins/git"; tags = ["from:oh-my-zsh"]; }
          { name = "plugins/kubectl"; tags = ["from:oh-my-zsh"]; }
          { name = "plugins/helm"; tags = ["from:oh-my-zsh"]; }
          { name = "plugins/docker"; tags = ["from:oh-my-zsh"]; }
          { name = "plugins/cp"; tags = ["from:oh-my-zsh"]; }
          { name = "plugins/man"; tags = ["from:oh-my-zsh"]; }
        ];
      };
      history = {
        save = 10000000;
        size = 10000000;
      };
      shellAliases = {
        watch = "watch ";
        vim = "nvim";
        vims = "NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim";
        vimr = "nvr --remote";
        ls = "ls -G";
        gpgbye = "gpg-connect-agent updatestartuptty /bye";
        ssh = "TERM=xterm ssh";
        tmux = "tmux -u";
        kush = "kubectl run ubuntu --rm -i --tty --image ubuntu -- bash";
      };
      initExtra = ''
        export GPG_TTY="$(tty)"
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
        gpgconf --launch gpg-agent

        # Disable the underline for paths
        typeset -A ZSH_HIGHLIGHT_STYLES
        ZSH_HIGHLIGHT_STYLES[path]='none'
      '';
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      # Configuration written to ~/.config/starship.toml
      settings = {
        # add_newline = false;

        # character = {
        #   success_symbol = "[➜](bold green)";
        #   error_symbol = "[➜](bold red)";
        # };

        golang.symbol = " ";
        docker_context.symbol = " ";
        directory.read_only = " ";
        aws.symbol = "  ";
        git_branch.symbol = " ";
        java.symbol = " ";
        memory_usage.symbol = " ";
        nix_shell.symbol = " ";
        package.symbol = " ";
        python.symbol = " ";
        rust.symbol = " ";
        shlvl.symbol = " ";
        gcloud.symbol = " ";
        terraform.symbol = "行";
      };
    };

    xdg.dataFile."nvim/site/pack/paqs/start/paq-nvim".source = pkgs.fetchFromGitHub {
      owner = "savq";
      repo = "paq-nvim";
      rev = "cdde12dfbe715df6b9d3a2774714c25fdbee86ec";
      sha256 = "0jnxf79rcn0fhxg6m140lzxixvq1zivkg7c43ra64mwzb8wxvv8l";
    };

    xdg.configFile."nvim/lua/init.lua".text = ''
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


      require "paq" { -- paq itself has to be updated via nix!
        -- TODO: maybe moving plugins to nix would make sense...
      	-- some vim essentials
      	{"tpope/vim-commentary"};
        {"tpope/vim-surround"};
        {"tpope/vim-unimpaired"};
        {"tpope/vim-repeat"};
        -- some neovim essentials
        {"nvim-treesitter/nvim-treesitter", run=":TSUpdate"};
        {"neovim/nvim-lspconfig"};
        {"hrsh7th/nvim-compe"}; -- TODO: maybe nvim-lua/completion-nvim is an alternative?
        -- colorscheme
        {"rktjmp/lush.nvim"};
        {"npxbr/gruvbox.nvim"};
        -- telescope
        {"nvim-lua/popup.nvim"};
        {"nvim-lua/plenary.nvim"};
        {"nvim-telescope/telescope.nvim"};
        {"nvim-telescope/telescope-fzf-native.nvim", run="make" };
        -- statusline
        {"kyazdani42/nvim-web-devicons"};
        {"hoob3rt/lualine.nvim"};
        -- buffer tabs
        {"jose-elias-alvarez/buftabline.nvim"};
        -- utility
        {"mg979/vim-visual-multi"};
        {"lewis6991/gitsigns.nvim"}; -- depends on nvim-lua/plenary.nvim
        {"unblevable/quick-scope"}; -- f/F/t/T preview
        {"justinmk/vim-sneak"}; -- s<char><char>
        {"ntpeters/vim-better-whitespace"}; -- whitespace cleanup
        {"dstein64/nvim-scrollview"}; -- scrollbar
        {"lukas-reineke/indent-blankline.nvim"};
        -- language support
        {"LnL7/vim-nix"};
        {"hashivim/vim-terraform"};
      }


      -- Gitsigns
      require "gitsigns".setup {}


      -- Treesitter
      require "nvim-treesitter.configs".setup {
        ensure_installed = "maintained",
        highlight = {
          enable = true,
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

      -- Easier split navigation
      map("n", "<C-J>", "<C-W><C-J>", {noremap=true})
      map("n", "<C-K>", "<C-W><C-K>", {noremap=true})
      map("n", "<C-L>", "<C-W><C-L>", {noremap=true})
      map("n", "<C-H>", "<C-W><C-H>", {noremap=true})

      -- Additional keybindings
      map("n", "<C-x>", ":BufNext<CR>", {noremap=true}) -- requires buftabline.nvim
      map("n", "<C-z>", ":BufPrev<CR>", {noremap=true}) -- requires buftabline.nvim
      map("n", "<leader>w", ":w!<cr>")
      map("", "<Up>", "gk")
      map("", "<Down>", "gj")
      map("", "k", "gk")
      map("", "j", "gj")
      map("i", "jk", "<ESC>")
      map("i", "<leader><leader>", "<C-X><C-O>")
      map("n", "<leader>d", "\"_d", {noremap=true})
      map("x", "<leader>d", "\"_d", {noremap=true})
      map("n", "<leader>p", "\"0p", {noremap=true})
      map("x", "<leader>p", "\"0p", {noremap=true})
      map("", "<Leader>c", ":ccl <bar> lcl<CR>", {noremap=true})


      -- Lualine with icons
      require "nvim-web-devicons".setup {
        default = true;
      }
      require "lualine".setup {
        options = {
          icons_enabled = true,
          theme = "gruvbox",
          component_separators = {"｜", "｜"},
          section_separators = {" ", " "},
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

      -- Buffer tabs
      require "buftabline".setup {
        icons = true,
        hlgroup_current = "StatusLine",
        hlgroup_normal = "StatusLineNC",
      }

      -- Telescope
      require('telescope').setup {
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = false, -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
          }
        }
      }
      require('telescope').load_extension('fzf')

      map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", {noremap=true})
      map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {noremap=true})
      map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", {noremap=true})
      map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", {noremap=true})



      -- Code completion
      require "compe".setup {
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'enable';
        throttle_time = 80;
        source_timeout = 200;
        resolve_timeout = 800;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = {
          border = { "", "", "", " ", "", "", "", " " }, -- the border option is the same as `|help nvim_open_win|`
          winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
          max_width = 120,
          min_width = 60,
          max_height = math.floor(vim.o.lines * 0.3),
          min_height = 1,
        };

        source = {
          path = true;
          buffer = true;
          calc = true;
          nvim_lsp = true;
          nvim_lua = true;
          vsnip = false;
          ultisnips = false;
          luasnip = false;
        };
      }

      local opts = { silent=true, expr=true, noremap=true }
      map("i", "<C-Space>", "compe#complete()", opts)
      map("i", "<CR>", "compe#confirm('<CR>')", opts)
      map("i", "<C-e>", "compe#close('<C-e>')", opts)
      map("i", "<C-f>", "compe#scroll({ 'delta': +4 })", opts)
      map("i", "<C-d>", "compe#scroll({ 'delta': -4 })", opts)


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
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          },
        }
      end


      -- Terraform
      g.terraform_align = 0
      g.terraform_fmt_on_save = 1

      -- Indentation defaults
      cmd [[
        autocmd Filetype bash setlocal ts=2 sw=2 expandtab
        autocmd Filetype sh setlocal ts=2 sw=2 expandtab
        autocmd FileType yaml setlocal ts=2 sw=2 expandtab
        autocmd FileType nix setlocal ts=2 sw=2 expandtab
        autocmd Filetype gohtmltmpl setlocal ts=2 sw=2 expandtab
        autocmd Filetype proto setlocal ts=2 sw=2 expandtab
        " terragrunt
        au BufRead,BufNewFile *.hcl set filetype=terraform
      ]]
    '';

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = "lua require('init')";
    };
  };
}
