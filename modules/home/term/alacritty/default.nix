{ config, options, pkgs, lib, mylib, ... }:
with lib;
with mylib;
let
  cfg = config.my.term.alacritty;

  alacrittyTheme = pkgs.fetchFromGitHub {
    owner = "eendroroy";
    repo = "alacritty-theme";
    rev = "dd3a1ef22585b93a59da98a01ca8b641e0484bb9";
    sha256 = "053shryakxvw7yrhycflxxcdw3sqgxf3ii5914d4x6d4f5vzsxf3";
  };
in
{
  options.my.term.alacritty = with types; {
    enable = mkBoolOpt false;
    fontSize = mkOption {
      type = types.float;
      default = 10.0;
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."alacritty/alacritty.yml".source = pkgs.substituteAll {
      src = ./alacritty.yml.tpl;
      fontSize = cfg.fontSize;
      colorScheme = builtins.readFile ("${alacrittyTheme}/themes/gruvbox_dark.yaml");
    };

    programs.alacritty = (mkMerge [
      (mkIf config.my.nixGL.enable {
        enable = true;
        package = (pkgs.writeShellScriptBin "alacritty" ''
          ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.alacritty}/bin/alacritty "$@"
        '');
      })
      (mkIf (config.my.nixGL.enable != true) {
        enable = true;
      })
    ]);
  };
}
