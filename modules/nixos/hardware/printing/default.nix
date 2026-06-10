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
      nssmdns4 = true;
      openFirewall = true;
    };

    hardware.printers = {
      ensureDefaultPrinter = "Brother_MFC_L2750DW_series";
      ensurePrinters = [{
        name = "Brother_MFC_L2750DW_series";
        location = "Home";
        deviceUri = "ipp://brwdce99402badc/ipp/print";
        model = "everywhere";
      }];
    };
  };
}
