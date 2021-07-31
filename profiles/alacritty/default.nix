{ config, pkgs, ... }:
{
  my.home = {
    xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;

    programs.alacritty = {
      enable = true;
    };
  };
}
