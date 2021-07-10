{ config, pkgs, lib, profiles, ... }:

{
  imports = with profiles; [ base neovim alacritty zsh ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.nix.configureBuildUsers = true;
  services.nix-daemon.enable = true;
}
