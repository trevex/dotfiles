{ config
, options
, lib
, pkgs
, mylib
, ...
}:
with lib;
with mylib; let
  cfg = config.my.editors.helix;
in
{
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
          language-server = { command = lib.getExe pkgs.unstable.nil; };
          config.nil.formatting.command = [ (lib.getExe pkgs.unstable.alejandra) "-q" ];
        }
        {
          name = "rust";
          auto-format = true;
          language-server = {
            command = lib.getExe pkgs.unstable.rust-analyzer;
          };
          config.checkOnSave.command = (lib.getExe pkgs.unstable.clippy);
          debugger = {
            # TODO: make debug adapter configurate, to allow swapping to lldb directly, e.g. https://github.com/helix-editor/helix/blob/master/languages.toml
            command = "${pkgs.unstable.vscode-extensions.vadimcn.vscode-lldb.adapter}/bin/codelldb";
            name = "codelldb";
            port-arg = "--port {}";
            transport = "tcp";
            templates = [{
              name = "binary";
              request = "launch";
              completion = [{
                completion = "filename";
                name = "binary";
              }];
              args = {
                program = "{0}";
                runInTerminal = true;
              };
            }];
          };
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
          gutters = [ "diagnostics" "line-numbers" "spacer" "diff" ];
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

