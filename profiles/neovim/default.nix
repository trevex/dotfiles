# Expected to be used as "HomeProfile" (see ../default.nix).
{ config, pkgs, ... }:
let
  go-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "go.nvim";
    version = "29-11-2021";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "go.nvim";
      rev = "3329238deb8c2294d1b7f5ceffdeb3d5b31fe8be";
      sha256 = "14vw0nrn4qqshj8ajz6s0k5y96qn06j08nax12lf52by7cfvvni0";
    };
    prePatch = ''
      rm Makefile
    '';
  };
in
{
  home.packages = with pkgs; [
    # language servers
    gopls
    terraform-ls
    rnix-lsp
  ];

  # TODO: checkout https://github.com/glepnir/lspsaga.nvim
  #       related https://blog.inkdrop.info/how-to-set-up-neovim-0-5-modern-plugins-lsp-treesitter-etc-542c3d9c9887

  xdg.configFile."nvim/lua/init.lua".source = ./init.lua;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Plugin list can be found here:
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vim-plugins/vim-plugin-names
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vim-plugins/generated.nix
    plugins = with pkgs.vimPlugins; [
      # some vim essentials
      vim-commentary
      vim-surround
      vim-unimpaired
      vim-repeat
      vim-peekaboo
      # some neovim essentials
      nvim-treesitter
      nvim-lspconfig
      nvim-web-devicons
      nvim-tree-lua
      bufferline-nvim
      lualine-nvim # statusbar
      # code completion
      vim-vsnip # snippets
      friendly-snippets
      nvim-cmp
      cmp-vsnip
      cmp-nvim-lsp
      cmp-buffer
      cmp-tabnine
      cmp-path
      lspkind-nvim
      # colorscheme
      lush-nvim
      gruvbox-nvim
      # telescope
      popup-nvim
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-project-nvim
      # utility
      vim-visual-multi
      gitsigns-nvim # depends on nvim-lua/plenary.nvim
      quick-scope # f/F/t/T preview
      vim-sneak # s<char><char>
      vim-better-whitespace # whitespace cleanup
      indent-blankline-nvim
      symbols-outline-nvim
      # stabilize-nvim # TODO: not available yet :/
      dashboard-nvim # \o/
      # language support
      vim-nix
      vim-terraform
      vim-helm
      vim-go
    ];
    extraConfig = ''
      lua require('init')
    '';
  };
}
