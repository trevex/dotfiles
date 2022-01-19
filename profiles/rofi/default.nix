# Expected to be used as "LinuxHomeProfile" (see ../default.nix).
{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    font = "DejaVu Sans 15";
    theme = "${pkgs.rofi-unwrapped}/share/rofi/themes/gruvbox-dark.rasi";
  };
}
