{ config, options, lib, pkgs, home-manager, ... }:

with lib;
with lib.my;
{
  config = {
    # Make /etc/hosts a real, writable file instead of a read-only symlink
    # into the Nix store. Setting a mode other than "symlink" makes NixOS copy
    # the file into /etc, so tools that patch /etc/hosts at runtime work.
    # Note: `nixos-rebuild switch` regenerates it, so persistent entries still
    # belong in `networking.hosts` / `networking.extraHosts`.
    environment.etc.hosts.mode = "0644";

    environment.systemPackages = with pkgs; [
      vim
      inetutils
      git
      git-lfs
      ripgrep
      curl
      eza
      gcc
      bat
      moreutils
      tree
      gnumake
      unzip
      htop
      fd
      dig
      wget
      openssl
      tokei
      httpie
      jq
    ];
  };
}
