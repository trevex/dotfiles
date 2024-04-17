{ config, options, lib, pkgs, mylib, ... }:
with lib;
with mylib;
let
  cfg = config.my.desktop.browser.chromium;
in
{
  options.my.desktop.browser.chromium = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    # Some applications interact with power controls via DBus, e.g. Chromium
    services.upower.enable = true;

    my.home = {
      # Let's setup chromium and add our custom desktop item
      programs.chromium = {
        enable = true;
        extensions = [
          { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
          { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
        ];
        # Chromium is not properly leveraging HW-acceleration, so let's make sure
        # to enable it by passing in the required flags.
        package = (pkgs.chromium.override {
          commandLineArgs = [
            "--enable-features=UseOzonePlatform"
            "--ozone-platform=wayland"
            "--enable-features=VaapiVideoDecoder"
            "--enable-gpu-rasterization"
            # "--enable-zero-copy"
            # "--ignore-gpu-blocklist"
          ];
        });
      };
    };
  };
}
