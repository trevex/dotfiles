{
  config,
  options,
  lib,
  pkgs,
  mylib,
  ...
}:
with lib;
with mylib; let
  cfg = config.my.editors.helix;
in {
  options.my.editors.helix = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    programs.helix = {
      enable = true;
      package = pkgs.unstable.helix;

      languages = [
        {
          name = "nix";
          language-server = {command = lib.getExe pkgs.unstable.nil;};
          config.nil.formatting.command = [(lib.getExe pkgs.unstable.alejandra) "-q"];
        }
      ];

      settings = {
        theme = "gruvbox";
        editor = {
          bufferline = "multiple";
          true-color = true;
          color-modes = true;
          cursorline = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides = {
            render = true;
          };
          statusline = {
            mode = {
              normal = "NORMAL";
              insert = "INSERT";
              select = "SELECT";
            };
          };
          gutters = ["diagnostics" "line-numbers" "spacer" "diff"];
        };
        keys = {
          insert = {
            j = { k = "normal_mode"; };
          };
        };
      };
    };

  };
}
