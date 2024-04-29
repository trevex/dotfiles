{ config, options, lib, pkgs, mylib, ... }:

with lib;
with mylib;
let cfg = config.my.shell.yubikey;
in
{
  options.my.shell.yubikey = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # We just use FIDO2, e.g.
    # ssh-keygen -t ecdsa-sk -O resident -O application=ssh:YourTextHere -O verify-required

    environment.systemPackages = with pkgs; [
      yubikey-manager
    ];

    services.pcscd.enable = true;
  };
}
