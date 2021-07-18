{ config, pkgs, ... }:
{
  my.home = {
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        pulseSupport = true;
      };
      config = ./config.ini;
      script = ''
        polybar top &
      '';
    };
  };
}
