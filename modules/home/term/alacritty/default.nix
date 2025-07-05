{ config, options, pkgs, lib, mylib, ... }:
with lib;
with mylib;
let
  cfg = config.my.term.alacritty;
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
    xdg.configFile."alacritty/alacritty.toml".source = pkgs.replaceVars ./alacritty.toml.tpl {
      fontSize = cfg.fontSize;
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
