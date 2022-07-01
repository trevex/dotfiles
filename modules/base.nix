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
      exa
      gcc
      bat
      moreutils
      tree
      gnumake
      unzip
      protobuf
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
