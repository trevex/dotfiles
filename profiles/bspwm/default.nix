{ config, pkgs, lib, ... }:
with lib;
let
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
  focusMover = pkgs.writeScriptBin "focus-mover" ''
    #!${pkgs.stdenv.shell}
    ${builtins.readFile ./scripts/focus-mover}
  '';
  euclidMover = pkgs.writeScriptBin "euclid-mover" ''
    #!${pkgs.stdenv.shell}
    ${builtins.readFile ./scripts/euclid-mover}
  '';
  autoPresel = pkgs.writeScriptBin "auto-presel" ''
    #!${pkgs.stdenv.shell}
    ${builtins.readFile ./scripts/auto-presel}
    '';
  windowPromoter = pkgs.writeScriptBin "window-promoter" ''
    #!${pkgs.stdenv.shell}
    ${builtins.readFile ./scripts/window-promoter}
  '';
  windowResize = pkgs.writeScriptBin "window-resize" ''
    #!${pkgs.stdenv.shell}
    ${builtins.readFile ./scripts/window-resize}
    '';
  whid = pkgs.writeScriptBin "whid" ''
    #!${pkgs.stdenv.shell}
    ${builtins.readFile ./scripts/whid}
  '';
in {
  # TODO: move some of the fundamental X11 stuff out...

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
          ${pkgs.xorg.xmodmap}/bin/xmodmap ${xkbCustomLayout}
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
    inactiveOpacity = 0.95;
    shadow = false;
    fadeDelta = 4;
  };

  # Install required tools to make all our keybindings and scripts work
  environment.systemPackages = [
    focusMover
    euclidMover
    autoPresel
    windowPromoter
    windowResize
    whid
  ] ++ (with pkgs; [
    brightnessctl
    scrot
    wmutils-core
    xdo
    xdotool
    ranger
  ]);

  my.home = { config, ... } : {
    # Let's also install some convenience tools to configure gtk etc.
    home.packages = with pkgs; [
      lxappearance
    ];

    # Make sure workspaces are shown in polybar, for this we need an additional
    # target to make sure polybar is not executed too early. And start it in
    # `bspwmrc`.
    # See https://github.com/nix-community/home-manager/issues/213#issuecomment-829743999
    systemd.user.targets.graphical-session-bspwm = {
      Unit = {
        Description = "bspwm X session";
        BindsTo = [ "graphical-session.target" ];
        Requisite = [ "graphical-session.target" ];
      };
    };
    systemd.user.services.polybar = mkIf (config.services.polybar.enable) {
      Unit.After = [ "graphical-session-bspwm.target" ];
      Install.WantedBy = mkForce [ "graphical-session-bspwm.target" ];
    };

    # Enable bspwm and sxhkd
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

    # By default home-manager xsession will set background image to
    # ~/.background-image using feh by default.
    home.file.".background-image".source = ./wallpaper.jpg;

    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
    };

    services.redshift = {
      enable = true;
      dawnTime = "6:00-8:00";
      duskTime = "19:00-20:00";
    };
    # There is no inbuilt screen-locker, so let's use betterlockscreen.
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
