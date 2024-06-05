{ options, config, lib, pkgs, mylib, ... }:

with lib;
with mylib;
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


    environment.systemPackages = with pkgs; [
      skopeo
      docker-compose
    ];
  };
}
