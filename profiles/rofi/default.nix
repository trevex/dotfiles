{ config, pkgs, ... }:
{
  my.home = {
    programs.rofi = {
      enable = true;
      font = "DejaVu Sans 15";
      theme = "${pkgs.rofi-unwrapped}/share/rofi/themes/gruvbox-dark.rasi";
    };
  };
}
