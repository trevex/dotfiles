{ inputs, config, options, pkgs, lib, mylib, ... }:
with lib;
with mylib;
let
  cfg = config.my.desktop.niri;
in
{
  options.my.desktop.niri = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.displayManager = {
      gdm.enable = true;
      gdm.wayland = true;
    };

    programs.niri.enable = true;
  };
}
