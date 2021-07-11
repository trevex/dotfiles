{ config, pkgs, ... }:
{

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    layout = "us";
    xkbOptions = "eurosign:e";
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    windowManager.bspwm.enable = true;
    displayManager.defaultSession = "xfce+bspwm";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.9;
    shadow = true;
    fadeDelta = 4;
  };

  my.home = {
    xdg.configFile."bspwm/bspwmrc".source = ./bspwmrc;
    xdg.configFile."sxhkd/sxhkdrc".source = ./sxhkdrc;
  };
}
