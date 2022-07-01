{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.my.services.docker;
in
{
  options.my.services.docker = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    my.user.extraGroups = [ "docker" ];

    virtualisation = {
      docker = {
        enable = true;
        autoPrune.enable = true;
        enableOnBoot = mkDefault false;
        # listenOptions = [];
      };
    };
  };
}
