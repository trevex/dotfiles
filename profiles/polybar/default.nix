{ config, pkgs, ... }:
{
  my.home = {
    services.polybar = {
      enable = true;
      config = ./config.ini;
      script = ''
        polybar top &
      '';
    };
  };
}
