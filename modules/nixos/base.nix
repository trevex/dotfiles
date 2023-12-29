{ config, options, lib, pkgs, home-manager, ... }:

with lib;
with lib.my;
{
  config = {
    environment.systemPackages = with pkgs; [
      vim
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
    ];
  };
}
