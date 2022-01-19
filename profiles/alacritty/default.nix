# Expected to be used as "LinuxHomeProfile".
# However without nixGL it will not work on non-NixOS!
{ config, pkgs, isLinux, isHomeManager, ... }:
let
  nixGLIntel = (pkgs.callPackage "${builtins.fetchTarball {
      url = https://github.com/guibou/nixGL/archive/58ab858a1b1059184e0cdb358f3470fa8ededeac.tar.gz;
      sha256 = "0jwk4ci3xn1v21pns01v36ilw5q9nrf02cb3ir1npm6m15744i04";
    }}/nixGL.nix"
    { }).nixGLIntel;
  alacrittyPackage =
    if isHomeManager && isLinux then
      (pkgs.writeShellScriptBin "alacritty" ''
        	#!/bin/bash
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
  xdg.configFile."alacritty/alacritty.yml".source = pkgs.substituteAll {
    src = ./alacritty.yml.tpl;
    fontSize = if isLinux then 8.0 else 16.0;
    colorScheme = builtins.readFile ("${alacrittyTheme}/themes/gruvbox_dark.yaml");
  };

  programs.alacritty = {
    enable = true;
    package = alacrittyPackage;
  };
}
