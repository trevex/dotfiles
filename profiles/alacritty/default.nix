{ config, pkgs, ... }:
{
  my.home = { pkgs, ... }:
  {
    xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;

    programs.alacritty = {
      enable = true;
    };
  };
}
