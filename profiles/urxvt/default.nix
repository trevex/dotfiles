# Expected to be used as "LinuxHomeProfile".
{ config, pkgs, isLinux, isHomeManager, ... }:
{
  home.packages = [ pkgs.glibcLocales ];

  programs.urxvt = {
    enable = true;
    fonts = [
      "xft:MesloLGS Nerd Font Mono:style=Regular:size=10"
      "xft:Material Design Icons:style=Regular:size=10"
      "xft:DejaVu Sans Mono:style=Book:size=10"
      "xft:Symbola:style=Regular:size=10"
    ];
    keybindings = {
      "Shift-Control-C" = "eval:selection_to_clipboard";
      "Shift-Control-V" = "eval:paste_clipboard";
    };
    iso14755 = false;
  };


  xresources.properties = {
    # gruvbox base16 + 256
    "*background" = "#282828";
    "*foreground" = "#ebdbb2";
    "*color0" = "#282828";
    "*color8" = "#928374";
    "*color1" = "#cc241d";
    "*color9" = "#fb4934";
    "*color2" = "#98971a";
    "*color10" = "#b8bb26";
    "*color3" = "#d79921";
    "*color11" = "#fabd2f";
    "*color4" = "#458588";
    "*color12" = "#83a598";
    "*color5" = "#b16286";
    "*color13" = "#d3869b";
    "*color6" = "#689d6a";
    "*color14" = "#8ec07c";
    "*color7" = "#a89984";
    "*color15" = "#ebdbb2";
    "URxvt.color24" = "#076678";
    "URxvt.color66" = "#427b58";
    "URxvt.color88" = "#9d0006";
    "URxvt.color96" = "#8f3f71";
    "URxvt.color100" = "#79740e";
    "URxvt.color108" = "#8ec07c";
    "URxvt.color109" = "#83a598";
    "URxvt.color130" = "#af3a03";
    "URxvt.color136" = "#b57614";
    "URxvt.color142" = "#b8bb26";
    "URxvt.color167" = "#fb4934";
    "URxvt.color175" = "#d3869b";
    "URxvt.color208" = "#fe8019";
    "URxvt.color214" = "#fabd2f";
    "URxvt.color223" = "#ebdbb2";
    "URxvt.color228" = "#f2e5bc";
    "URxvt.color229" = "#fbf1c7";
    "URxvt.color230" = "#f9f5d7";
    "URxvt.color234" = "#1d2021";
    "URxvt.color235" = "#282828";
    "URxvt.color236" = "#32302f";
    "URxvt.color237" = "#3c3836";
    "URxvt.color239" = "#504945";
    "URxvt.color241" = "#665c54";
    "URxvt.color243" = "#7c6f64";
    "URxvt.color244" = "#928374";
    "URxvt.color245" = "#928374";
    "URxvt.color246" = "#a89984";
    "URxvt.color248" = "#bdae93";
    "URxvt.color250" = "#d5c4a1";
  };
}
