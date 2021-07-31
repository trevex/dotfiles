{ config, pkgs, ... }:
{
  my.home = {
    programs.rofi = {
      enable = true;
      width = 40;
      lines = 8;
      borderWidth = 2;
      rowHeight = 1;
      padding = 5;
      font = "DejaVu Sans 15";
      separator = "solid";
      colors = {
        window = {
          background = "#3C3836";
          border = "#EBDBB2";
          separator = "#EBDBB2";
        };
        rows = {
          normal = {
            background = "#282828";
            foreground = "#FABD2F";
            backgroundAlt = "#282828";
            highlight = {
              background = "#FABD2F";
              foreground = "#282828";
            };
          };
        };
      };
    };
  };
}
