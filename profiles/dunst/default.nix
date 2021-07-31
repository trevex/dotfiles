{ config, pkgs, ... }:
{
  my.home = {
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
          width = 2;
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
  };
}
