{ options, config, lib, pkgs, mylib, ... }:

with lib;
with mylib;
let cfg = config.my.hardware.printing;
in
{
  options.my.hardware.printing = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };
    services.avahi = {
      enable = true;
      nssmdns = true;
    };
  };
}
