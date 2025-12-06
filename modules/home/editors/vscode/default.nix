{ config
, options
, lib
, pkgs
, mylib
, ...
}:
with lib;
with mylib; let
  cfg = config.my.editors.vscode;
in
{
  options.my.editors.vscode = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        jdinhlife.gruvbox
        golang.go
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        # {
        #   name = "drcika";
        #   publisher = "apc-extension";
        #   version = "0.4.1";
        #   sha256 = "sha256-6PLn7g/znfc2uruYTqxQ96IwXxfz6Sbguua3YqZe64U=";
        # }
      ];
    };
  };
}

