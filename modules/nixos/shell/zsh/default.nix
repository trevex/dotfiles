{ config, options, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.my.shell.zsh;
  inherit (pkgs) stdenv;
in
{
  options.my.shell.zsh = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;
    my.user.shell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = false; # we are using home-manager zsh, so do not enable!
    };
  };
}
