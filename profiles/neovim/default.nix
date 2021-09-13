{ config, pkgs, ... }:
let
  go-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "go-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "go.nvim";
      rev = "1988bf39aeb3570f31586ec3ac1d280f5967e44e";
      sha256 = "0pdfm88za0bhf6d85s8cjiqb322xdlcl70wn5zvnq7niym8n3pjn";
    };
    prePatch = ''
      rm Makefile
    '';
  };
in {
  my.home = {
    home.packages = with pkgs; [
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
        # some neovim essentials
        nvim-treesitter
        nvim-lspconfig
        nvim-compe
        nvim-web-devicons
        nvim-tree-lua
        nvim-bufferline-lua
        lualine-nvim # statusbar
        # colorscheme
        lush-nvim
        gruvbox-nvim
        # telescope
        popup-nvim
        plenary-nvim
        telescope-nvim
        # utility
        vim-visual-multi
        gitsigns-nvim # depends on nvim-lua/plenary.nvim
        quick-scope # f/F/t/T preview
        vim-sneak # s<char><char>
        vim-better-whitespace # whitespace cleanup
        indent-blankline-nvim
        # language support
        vim-nix
        vim-terraform
        vim-helm
        go-nvim
      ];
      extraConfig = ''
        lua require('init')
      '';
    };
  };
}
