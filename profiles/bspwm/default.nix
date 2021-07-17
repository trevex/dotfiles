{ config, pkgs, ... }:
{
  services.acpid.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    layout = "us";
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
      session = [{
        name = "home-manager";
        start = ''
          ${pkgs.stdenv.shell} $HOME/.xsession-hm &
          waitPID=$!
        '';
      }];
    };
    displayManager.defaultSession = "home-manager";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.9;
    shadow = false;
    fadeDelta = 4;
  };

  environment.systemPackages = with pkgs; [ brightnessctl ];

  services.logind.lidSwitch = "suspend";

  my.home = {
    xsession = {
      enable = true;
      scriptPath = ".xsession-hm";
      windowManager.bspwm = {
        enable = true;
        extraConfig = builtins.readFile ./bspwmrc;
      };
    };
    services.sxhkd = {
      enable = true;
      extraConfig = builtins.readFile ./sxhkdrc;
    };
    home.packages = with pkgs; [
      lxappearance
    ];
    home.file.".background-image".source = ./wallpaper.jpg;
    services.redshift = {
      enable = true;
      dawnTime = "6:00-8:00";
      duskTime = "19:00-20:00";
    };
    services.network-manager-applet.enable = true;
    services.screen-locker = {
      enable = true;
      inactiveInterval = 300;
      lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
      xautolockExtraOptions = [
        "Xautolock.killer: systemctl suspend"
      ];
    };
  };
}
