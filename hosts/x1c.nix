{ config, pkgs, lib, profiles, ... }:

{
  imports = with profiles; [ base zsh alacritty neovim ];
}
