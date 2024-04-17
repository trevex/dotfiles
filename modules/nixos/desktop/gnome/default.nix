{ inputs, config, options, pkgs, lib, mylib, ... }:
with lib;
with mylib;
with inputs.home-manager.lib.hm.gvariant;
let
  cfg = config.my.desktop.gnome;
in
{
  options.my.desktop.gnome = with types; {
    enable = mkBoolOpt false;
  };

  # TODO: gnome 43 broke lots of things...

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qt5.qtwayland
      dconf
      libnotify
      wl-clipboard
      alacritty
    ];

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-weather
      gnome-maps
    ]);

    services.xserver = {
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
      desktopManager.gnome.enable = true;
    };

    services.gnome.core-utilities.enable = true;
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    my.home = { config, pkgs, ... }: {
      home.packages = with pkgs; [
        gnome.nautilus
        gnome.gnome-shell-extensions
        gnomeExtensions.appindicator
        gnomeExtensions.pop-shell
        # gnomeExtensions.dynamic-panel-transparency does not work with gnome 43
      ];

      dconf = {
        enable = true;
        settings = {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = [
              "user-theme@gnome-shell-extensions.gcampax.github.com"
              # "workspace-indicator@gnome-shell-extensions.gcampax.github.com" obsolete in newest version
              "appindicatorsupport@rgcjonas.gmail.com"
              "pop-shell@system76.com"
              # "dynamic-panel-transparency@rockon999.github.io"
            ];
          };
          # "org/gnome/shell/extensions/user-theme" = {
          #   name = config.gtk.theme.name;
          # }; was broken by gnome 43
          "org/gnome/desktop/interface" = {
            monospace-font-name = "SFMono Nerd Font Mono 11";
            font-name = "SF Pro Text 11";
            color-scheme = "prefer-dark";
          };
          "org/gnome/desktop/background" = {
            primary-color = "#000000";
            secondary-color = "#000000";
            picture-uri = "file://${../bspwm/wallpaper.jpg}";
            picture-uri-dark = "file://${../bspwm/wallpaper.jpg}";
          };
          "org/gnome/desktop/peripherals/touchpad" = {
            tap-to-click = true;
            two-finger-scrolling-enabled = true;
          };
          "org/gnome/desktop/input-sources" = {
            current = "uint32 0";
            sources = [ (mkTuple [ "xkb" "de+us" ]) ];
            xkb-options = [ "terminate:ctrl_alt_bksp" ];
          };
          "org/gnome/mutter" = {
            edge-tiling = true;
            workspaces-only-on-primary = false;
            dynamic-workspaces = false;
            experimental-features = [ "scale-monitor-framebuffer" ];
          };
          "org/gnome/desktop/wm/preferences" = {
            num-workspaces = 4;
            focus-mode = "sloppy";
          };
          "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = true;
            night-light-temperature = "uint32 3500";
            night-light-schedule-automatic = true;
          };
          "org/gnome/eog/ui" = {
            image-gallery = true;
          };
          # Configure dynamic-panel-transparency
          "org/gnome/shell/extensions/dynamic-panel-transparency" = {
            enable-background-color = false;
            enable-opacity = true;
            panel-color = [ 80 73 69 ];
            unmaximized-opacity = 128;
          };
          # Enable and configure pop-shell
          # (see https://github.com/pop-os/shell/blob/master_jammy/scripts/configure.sh)
          "org/gnome/shell/extensions/pop-shell" = {
            active-hint = true;
          };
          "org/gnome/desktop/wm/keybindings" = {
            minimize = [ "<Super>comma" ];
            maximize = [ ];
            unmaximize = [ ];
            switch-to-workspace-left = [ ];
            switch-to-workspace-right = [ ];
            move-to-monitor-up = [ ];
            move-to-monitor-down = [ ];
            move-to-monitor-left = [ ];
            move-to-monitor-right = [ ];
            move-to-workspace-down = [ ];
            move-to-workspace-up = [ ];
            switch-to-workspace-down = [ "<Primary><Super>Down" "<Primary><Super>j" ];
            switch-to-workspace-up = [ "<Primary><Super>Up" "<Primary><Super>k" ];
            toggle-maximized = [ "<Super>f" ];
            close = [ "<Super>q" "<Alt>F4" ];
            switch-to-workspace-1 = [ "<Super>1" ];
            switch-to-workspace-2 = [ "<Super>2" ];
            switch-to-workspace-3 = [ "<Super>3" ];
            switch-to-workspace-4 = [ "<Super>4" ];
            move-to-workspace-1 = [ "<Super><Shift>1" ];
            move-to-workspace-2 = [ "<Super><Shift>2" ];
            move-to-workspace-3 = [ "<Super><Shift>3" ];
            move-to-workspace-4 = [ "<Super><Shift>4" ];
          };
          "org/gnome/shell/keybindings" = {
            open-application-menu = [ ];
            toggle-message-tray = [ "<Super>v" ];
            toggle-overview = [ ];
            switch-to-application-1 = [ ];
            switch-to-application-2 = [ ];
            switch-to-application-3 = [ ];
            switch-to-application-4 = [ ];
            switch-to-application-5 = [ ];
            switch-to-application-6 = [ ];
            switch-to-application-7 = [ ];
            switch-to-application-8 = [ ];
            switch-to-application-9 = [ ];
          };
          "org/gnome/mutter/keybindings" = {
            toggle-tiled-left = [ ];
            toggle-tiled-right = [ ];
          };
          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            ];
            screensaver = "@as ['<Super>Escape']";
            rotate-video-lock-static = [ ];
            home = [ "<Super>e" ];
            email = [ ];
            www = [ ];
            terminal = [ ];
          };
          "org/gnome/mutter/wayland/keybindings" = {
            restore-shortcuts = [ ];
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Super>z";
            command = "alacritty"; # TODO: use configured "default"
            name = "Open Alacritty";
          };
        };
      };
      gtk = {
        enable = true;
        iconTheme = {
          name = "Adwaita";
          package = pkgs.gnome.adwaita-icon-theme;
        };
        theme = {
          name = "Pop";
          package = pkgs.pop-gtk-theme;
        };
      };
      # qt = {
      #   enable = true;
      #   platformTheme = "gnome";
      # };
    };
  };
}
