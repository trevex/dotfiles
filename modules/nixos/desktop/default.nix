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
        (nerdfonts.override { fonts = [ "Meslo" ]; })
      ];
    };

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      # Configure keymap in X11
      layout = "us";
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };
  };
}
