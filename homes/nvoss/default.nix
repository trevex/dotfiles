{ config, pkgs, ... }:
{
  my = {
    desktop = {
      term = {
        alacritty.enable = true;
      };
    };
    editors = {
      default = "nvim";
      neovim.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      zsh.enable = true;
    };
  };
}
