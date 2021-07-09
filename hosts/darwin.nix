{ config, pkgs, lib, profiles, ... }:

{
  imports = with profiles; [ base ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  services.nix-daemon.enable = true;
}
