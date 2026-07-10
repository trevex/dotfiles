{ options, config, lib, pkgs, mylib, ... }:

with lib;
with mylib;
let
  cfg = config.my.hardware.printing;
  # mDNS host of the network printer; keep in sync with the deviceUri below.
  printerHost = "brwdce99402badc";
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
        deviceUri = "ipp://${printerHost}/ipp/print";
        model = "everywhere";
      }];
    };

    # The "everywhere" (IPP Everywhere) model makes lpadmin contact the printer
    # live during activation. When the printer is asleep/off this fails and
    # aborts the whole nixos-rebuild. Probe reachability first: if the printer
    # is unreachable, ExecCondition fails and systemd skips the unit cleanly
    # (condition-not-met, not failed) instead of breaking the switch.
    systemd.services.ensure-printers.serviceConfig.ExecCondition =
      pkgs.writeShellScript "printer-reachable" ''
        exec ${pkgs.coreutils}/bin/timeout 3 \
          ${pkgs.bash}/bin/bash -c 'echo > /dev/tcp/${printerHost}/631'
      '';
  };
}
