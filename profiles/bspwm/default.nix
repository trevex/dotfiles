{ config, pkgs, lib, isHomeManager, ... }:
with lib;
let
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
  systemPackages = [
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
    xsel
    xclip
  ]);
  homePackages = with pkgs; [
    lxappearance
  ] ++ (if isHomeManager then systemPackages else [ ]);
  home = {
    # Let's also install some convenience tools to configure gtk etc.
    home.packages = homePackages;

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
    systemd.user.services.polybar = mkIf (config.my.home.services.polybar.enable) {
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

    # gtk = {
    #   enable = true;
    #   iconTheme = {
    #     name = "Papirus";
    #     package = pkgs.papirus-icon-theme;
    #   };
    # };

    services.picom = {
      enable = true;
      experimentalBackends = true;
      fade = true;
      inactiveOpacity = "1.0";
      shadow = false;
      fadeDelta = 4;
      extraOptions = ''
        corner-radius = 4.0;

        rounded-corners-exclude = [
          "window_type = 'dock'",
          "window_type = 'desktop'",
          "window_type = 'toolbar'",
          "window_type = 'menu'",
          "window_type = 'dropdown_menu'",
          "window_type = 'popup_menu'",
          "window_type = 'tooltip'"
        ];
      '';
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
      lockCmd = "${pkgs.i3lock-color}/bin/i3lock-color -n -c 1d2021 --indicator -k --time-color=#ebdbb2ff --date-color=#ebdbb2ff --inside-color=#1d2021cc --insidever-color=#1d202100 --insidewrong-color=#cc241dcc --ring-color=#689d6aff --ringver-color=#689d6a00 --ringwrong-color=#fb4934ff --keyhl-color=#b16286ff --bshl-color=#d79921ff --verif-color=#00000000 --wrong-color=#00000000 --line-uses-inside --ring-width 5 --pass-media-keys --separator-color=#00000000";
      xautolock = {
        enable = true;
        detectSleep = true;
      };
      xautolock.extraOptions = [
        "Xautolock.killer: systemctl suspend"
      ];
    };
  };
in
if isHomeManager then home else
{
  # Install required tools to make all our keybindings and scripts work
  environment.systemPackages = systemPackages;

  my.home = home;
}
