{ config, options, lib, pkgs, mylib, ... }:

with lib;
with mylib;
let cfg = config.my.shell.direnv;
in
{
  options.my.shell.direnv = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # https://github.com/nix-community/nix-direnv
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
  };
}
