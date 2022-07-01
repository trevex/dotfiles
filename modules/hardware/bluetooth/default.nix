{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.my.hardware.bluetooth;
in
{
  options.my.hardware.bluetooth = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;

    services.blueman.enable = true; # applet explicitly enabled below via home-manager
    my.home = {
      services.blueman-applet.enable = true;
    };
  };
}
