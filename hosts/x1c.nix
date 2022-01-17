{ config, pkgs, lib, profiles, ... }:

{
  imports = with profiles; [ base neovim alacritty zsh ];
}
