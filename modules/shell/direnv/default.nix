{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.my.shell.direnv;
in
{
  options.my.shell.direnv = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    my.home = { ... }: {
      # https://github.com/nix-community/nix-direnv
      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;
    };
  };
}
