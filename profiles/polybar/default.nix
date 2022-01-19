# Expected to be used as "LinuxHomeProfile" (see ../default.nix).
{ config, pkgs, ... }:
{
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
}
