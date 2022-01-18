{ config, pkgs, isLinux, isHomeConfig, ... }:
let
  nixGLIntel = (pkgs.callPackage "${builtins.fetchTarball {
      url = https://github.com/guibou/nixGL/archive/17c1ec63b969472555514533569004e5f31a921f.tar.gz;
      sha256 = "0yh8zq746djazjvlspgyy1hvppaynbqrdqpgk447iygkpkp3f5qr";
    }}/nixGL.nix"
    { }).nixGLIntel;
  alacrittyPackage =
    if isHomeConfig then
      (pkgs.writeShellScriptBin "alacritty" ''
        	#!/bin/bash
        	export LD_PRELOAD=/lib/x86_64-linux-gnu/libnss_sss.so.2
          ${nixGLIntel}/bin/nixGLIntel ${pkgs.alacritty}/bin/alacritty "$@"
      '') else pkgs.alacritty;
  alacritty-theme = pkgs.fetchFromGitHub {
    owner = "eendroroy";
    repo = "alacritty-theme";
    rev = "dd3a1ef22585b93a59da98a01ca8b641e0484bb9";
    sha256 = "053shryakxvw7yrhycflxxcdw3sqgxf3ii5914d4x6d4f5vzsxf3";
  };
  home = {
    xdg.configFile."alacritty/alacritty.yml".source = pkgs.substituteAll {
      src = ./alacritty.yml.tpl;
      fontSize = if isLinux then 8.0 else 16.0;
      colorScheme = builtins.readFile ("${alacritty-theme}/themes/gruvbox_dark.yaml");
    };

    programs.alacritty = {
      enable = true;
      package = alacrittyPackage;
    };
  };
in
if isHomeConfig then home else
{
  my.home = home;
}
