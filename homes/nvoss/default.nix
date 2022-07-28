{ config, pkgs, ... }:
{
  my = {
    term = {
      alacritty.enable = true;
    };
    editors = {
      neovim.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      zsh.enable = true;
    };
  };

  home.packages = with pkgs; [
    signal-desktop
  ];
}
