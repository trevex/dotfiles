{ options, config, lib, pkgs, mylib, ... }:

with lib;
with mylib;
let
  cfg = config.my.services.tailscale;
in
{
  options.my.services.tailscale = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
  };
}
