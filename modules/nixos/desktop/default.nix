{ config, options, lib, pkgs, mylib, ... }:

with lib;
with mylib;
let
  cfg = config.my.desktop;
in
{
  config = mkIf (cfg.bspwm.enable || cfg.gnome.enable) {
    # || cfg.swaywm.enable
    services.acpid.enable = true;

    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
        dejavu_fonts
        material-design-icons
        apple-fonts
        nerd-fonts.meslo-lg
      ];
    };

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      # Configure keymap in X11
      xkb.layout = "us";
    };
    services.libinput = {
      enable = true;
    };
  };
}
