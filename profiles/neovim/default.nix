{ config, pkgs, ... }:
{
  my.home = {
    home.packages = with pkgs; [
      gopls
      terraform-ls
      rnix-lsp
    ];

    xdg.dataFile."nvim/site/pack/paqs/start/paq-nvim".source = pkgs.fetchFromGitHub {
      owner = "savq";
      repo = "paq-nvim";
      rev = "cdde12dfbe715df6b9d3a2774714c25fdbee86ec";
      sha256 = "0jnxf79rcn0fhxg6m140lzxixvq1zivkg7c43ra64mwzb8wxvv8l";
    };

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
        # some neovim essentials
        nvim-treesitter
        nvim-lspconfig
        nvim-compe
        # colorscheme
        lush-nvim
        gruvbox-nvim
        # telescope
        popup-nvim
        plenary-nvim
        telescope-nvim
        # telescope-fzf-native-nvim
        # statusbar
        nvim-web-devicons
        lualine-nvim
        # utility
        vim-visual-multi
        gitsigns-nvim # depends on nvim-lua/plenary.nvim
        quick-scope # f/F/t/T preview
        vim-sneak # s<char><char>
        vim-better-whitespace # whitespace cleanup
        nvim-scrollview # scrollbar
        indent-blankline-nvim
        # language support
        vim-nix
        vim-terraform
      ];
      extraConfig = ''
        lua require('init')
      '';
    };
  };
}
