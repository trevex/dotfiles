{ config, options, lib, pkgs, mylib, ... }:
with lib;
with mylib;
let
  cfg = config.my.editors.neovim;
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
  options.my.editors.neovim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # language servers
      unstable.gopls
      unstable.terraform-ls
      unstable.rnix-lsp
      unstable.nodePackages.typescript-language-server
      unstable.rust-analyzer
      unstable.clippy
      unstable.vimv
    ];

    # TODO: checkout https://github.com/glepnir/lspsaga.nvim
    #       related https://blog.inkdrop.info/how-to-set-up-neovim-0-5-modern-plugins-lsp-treesitter-etc-542c3d9c9887

    # TODO: compose config and make some plugins optionals
    #       we could check in lua as well:
    #       local status, test = pcall(require, "test")
    #       if(status) then

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
        nvim-treesitter.withAllGrammars
        nvim-lspconfig
        nvim-web-devicons
        nvim-tree-lua
        nvim-cokeline
        lualine-nvim # statusbar
        # code completion
        vim-vsnip # snippets
        friendly-snippets
        nvim-cmp
        cmp-vsnip
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        lspkind-nvim
        # colorscheme
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
        vim-jsx-typescript
        vim-nix
        vim-terraform
        vim-helm
        vim-go
        # workaround https://github.com/simrat39/rust-tools.nvim/issues/312#issuecomment-1374666492
        pkgs.unstable.vimPlugins.rust-tools-nvim
      ];
      extraConfig = ''
        lua require('init')
      '';
    };
  };
}
