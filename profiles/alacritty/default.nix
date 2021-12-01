{ config, pkgs, isLinux, ... }:
{
  my.home = {
    xdg.configFile."alacritty/alacritty.yml".source = pkgs.substituteAll {
      src = ./alacritty.yml.tpl;
      fontSize = if isLinux then 8.0 else 16.0;
    };

    programs.alacritty = {
      enable = true;
    };
  };
}
