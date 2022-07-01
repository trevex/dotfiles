{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.my.desktop;
  xkbCustomLayout = pkgs.writeText "xkb-layout" ''
    ! Map umlauts to RIGHT ALT + <key>
    keycode 108 = Mode_switch
    keysym e = e E EuroSign
    keysym c = c C cent
    keysym a = a A adiaeresis Adiaeresis
    keysym o = o O odiaeresis Odiaeresis
    keysym u = u U udiaeresis Udiaeresis
    keysym s = s S ssharp
  '';
in
{
  config = mkIf (cfg.bspwm.enable) {
    # || cfg.swaywm.enable
    services.acpid.enable = true;

    fonts = {
      fontDir.enable = true;
      fonts = with pkgs; [
        dejavu_fonts
        material-design-icons
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
      # By default we use our custom `.xsession-hm`, see bspwm-profile for an example in providing it
      desktopManager = {
        xterm.enable = false;
        wallpaper.mode = "fill";
        session = [{
          name = "home-manager";
          start = ''
            ${pkgs.xorg.xmodmap}/bin/xmodmap ${xkbCustomLayout}
            ${pkgs.stdenv.shell} $HOME/.xsession-hm &
            waitPID=$!
          '';
        }];
      };
      displayManager.defaultSession = "home-manager";
    };
  };
}
