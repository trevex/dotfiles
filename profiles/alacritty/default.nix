{ config, pkgs, isLinux, ... }:
let
  alacritty-theme = pkgs.fetchFromGitHub {
    owner = "eendroroy";
    repo = "alacritty-theme";
    rev = "dd3a1ef22585b93a59da98a01ca8b641e0484bb9";
    sha256 = "053shryakxvw7yrhycflxxcdw3sqgxf3ii5914d4x6d4f5vzsxf3";
  };
in
{
  my.home = {
    xdg.configFile."alacritty/alacritty.yml".source = pkgs.substituteAll {
      src = ./alacritty.yml.tpl;
      fontSize = if isLinux then 8.0 else 16.0;
      colorScheme = builtins.readFile ("${alacritty-theme}/themes/gruvbox_dark.yaml");
    };

    programs.alacritty = {
      enable = true;
    };
  };
}
