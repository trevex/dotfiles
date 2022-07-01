{ config, options, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.my.desktop.term.alacritty;

  nixGLIntel = (pkgs.callPackage "${builtins.fetchTarball {
      url = https://github.com/guibou/nixGL/archive/58ab858a1b1059184e0cdb358f3470fa8ededeac.tar.gz;
      sha256 = "0jwk4ci3xn1v21pns01v36ilw5q9nrf02cb3ir1npm6m15744i04";
    }}/nixGL.nix"
    { }).nixGLIntel;
  # NOTE: the below override will require you to create your own desktop item!
  alacrittyPackage =
    if true then
      (pkgs.writeShellScriptBin "alacritty" ''
        ${nixGLIntel}/bin/nixGLIntel ${pkgs.alacritty}/bin/alacritty "$@"
      '') else pkgs.alacritty;
  alacrittyTheme = pkgs.fetchFromGitHub {
    owner = "eendroroy";
    repo = "alacritty-theme";
    rev = "dd3a1ef22585b93a59da98a01ca8b641e0484bb9";
    sha256 = "053shryakxvw7yrhycflxxcdw3sqgxf3ii5914d4x6d4f5vzsxf3";
  };
in
{
  options.my.desktop.term.alacritty = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    my.home = {
      xdg.configFile."alacritty/alacritty.yml".source = pkgs.substituteAll {
        src = ./alacritty.yml.tpl;
        fontSize = 8.0;
        colorScheme = builtins.readFile ("${alacrittyTheme}/themes/gruvbox_dark.yaml");
      };

      programs.alacritty = {
        enable = true;
        package = alacrittyPackage;
      };
    };
  };
}
