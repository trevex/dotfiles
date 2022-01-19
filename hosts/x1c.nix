{ config, pkgs, lib, profiles, ... }:

{
  imports = with profiles; [ base zsh urxvt alacritty neovim bspwm rofi ];
  xsession.initExtra = ''
    export DESKTOP_SESSION=gnome
  '';
}
