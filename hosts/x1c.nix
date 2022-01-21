{ config, pkgs, lib, profiles, ... }:

{
  imports = with profiles; [ base zsh alacritty neovim ];
  xsession.initExtra = ''
    export DESKTOP_SESSION=gnome
  '';
}
