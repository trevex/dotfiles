{ config, pkgs, ... }:
{
  my.home = { pkgs, ... }:
  {
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
      extraConfig = ''
        lua require('init')
      '';
    };
  };
}
