{ inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let sys = "x86_64-linux";
in
{
  mkHome = path: attrs @ { system ? sys, ... }:
    let
      username = removeSuffix ".nix" (baseNameOf path);
      homeDirectory = "/home/${username}";
      defaults = { config, pkgs, lib, ... }: {
        imports =
          # All my personal modules
          (mapModulesRec' (toString ../modules/home) import);

        programs.home-manager.enable = true;
        xdg.enable = true;
        xdg.mime.enable = true;
        targets.genericLinux.enable = true;
        # home.sessionVariables = {
        #   EDITOR = "nvim";
        #   BROWSER = "google-chrome";
        #   TERMINAL = "alacritty";
        # };
        home.stateVersion = "22.05";
        home.username = username;
        home.homeDirectory = homeDirectory;
      };
      configuration = { ... }: {
        nixpkgs.pkgs = pkgs;
        imports = [ ];
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        defaults
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        (import path)
      ];
      extraSpecialArgs = {
        inherit lib inputs system;
      };
    };

  mapHomes = dir: attrs @ { system ? system, ... }:
    mapModules dir
      (homePath: mkHome homePath attrs);
}
