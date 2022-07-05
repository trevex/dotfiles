{ config, options, pkgs, lib, mylib, ... }:
with lib;
with mylib;
let
  cfg = config.my.desktop.bspwm;

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
in
{
  options.my.desktop.bspwm = with types; {
    enable = mkBoolOpt false;
  };


  config = mkIf cfg.enable {
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
      xsel
      xclip
      # some other relevant apps
      font-manager
      dconf
      libnotify
    ]);

    my.home = {
      services.network-manager-applet.enable = true;

      services.polybar = {
        enable = true;
        package = pkgs.polybar.override {
          pulseSupport = true;
        };
        config = ./polybar.ini;
        script = ''
          polybar top &
        '';
      };

      services.dunst = {
        enable = true;
        settings = rec {
          global = {
            font = "DejaVu Sans 12";
            allow_markup = true;
            format = "<b>%s</b>\\n%s";
            sort = true;
            indicate_hidden = true;
            alignment = "left";
            bounce_freq = 20;
            show_age_threshold = 60;
            word_wrap = true;
            ignore_newline = false;
            geometry = "600x5-30+30";
            shrink = true;
            transparency = 10;
            idle_threshold = 120;
            monitor = 1;
            follow = "keyboard";
            sticky_history = true;
            history_length = 20;
            show_indicators = false;
            line_height = 1;
            separator_height = 2;
            padding = 8;
            horizontal_padding = 16;
            separator_color = "frame";
            startup_notification = false;
            dmenu = "rofi -dmenu -p dunst:";
            browser = "xdg-open";
            icon_position = "left";
          };
          frame = {
            width = 4;
            color = "#ebdbb2";
          };
          shortcuts = {
            close = "ctrl+space";
            close_all = "ctrl+shift+space";
            history = "ctrl+dead_acute";
            context = "ctrl+shift+dead_acute";
          };
          urgency_low = {
            background = "#282828";
            foreground = "#a89984";
            timeout = 10;
          };
          urgency_normal = {
            background = "#282828";
            foreground = "#ebdbb2";
            timeout = 10;
          };
          urgency_critical = {
            background = "#282828";
            foreground = "#fb4934";
            timeout = 0;
          };
          spotify = {
            appname = "Spotify";
            background = "#282828";
            foreground = "#b8bb26";
            timeout = 5;
          };
        };
      };

      programs.rofi = {
        enable = true;
        font = "DejaVu Sans 15";
        theme = "${pkgs.rofi-unwrapped}/share/rofi/themes/gruvbox-dark.rasi";
      };

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

      gtk = {
        enable = true;
        iconTheme = {
          name = "Papirus";
          package = pkgs.papirus-icon-theme;
        };
      };

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
  };
}
