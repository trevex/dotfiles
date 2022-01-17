{ config, lib, pkgs, isLinux, isDarwin, ... }:
let
  inherit (config.my) username;
in
{
  my.home = { ... }: {
    my.identity = {
      name = "Niklas Voss";
      email = "nvoss@google.com";
      gpgSigningKey = "TODO";
    };
  };
}
