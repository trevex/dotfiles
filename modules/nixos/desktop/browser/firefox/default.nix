{ config, options, lib, pkgs, mylib, ... }:
with lib;
with mylib;
let
  cfg = config.my.desktop.browser.firefox;
in
{
  options.my.desktop.browser.firefox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.upower.enable = true;

    my.home = {

      programs.firefox = {
        enable = true;
        profiles = {
          default = {
            id = 0;
            name = "default";
            isDefault = true;
            settings = {
              "browser.search.defaultenginename" = "Google";
              "browser.search.order.1" = "Google";
            };
            search = {
              force = true;
              default = "Google";
              order = [ "Google" ];
              engines = {
                "Nix Packages" = {
                  urls = [{
                    template = "https://search.nixos.org/packages";
                    params = [
                      { name = "type"; value = "packages"; }
                      { name = "query"; value = "{searchTerms}"; }
                    ];
                  }];
                  icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@np" ];
                };
                "NixOS Wiki" = {
                  urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
                  iconUpdateURL = "https://nixos.wiki/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [ "@nw" ];
                };
                "Bing".metaData.hidden = true;
                "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
              };
            };
            # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            #   ublock-origin
            #   bitwarden
            #   darkreader
            #   vimium
            # ];
          };
        };
      };
    };
  };
}
