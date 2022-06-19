{ config, lib, pkgs, isNixos, isDarwin, ... }:

let
  inherit (config.my) username;
in
lib.mkMerge [
  (lib.optionalAttrs isNixos {
    # users.users.${username} = {
    #   createHome = true;
    #   isNormalUser = true;
    #   shell = pkgs.zsh;
    #   uid = 1000;
    #   group = username;
    #   home = "/home/${username}";
    #   extraGroups = [ "wheel" "networkmanager" "input" "audio" "video" "dialout" ]
    #     ++ (lib.optional config.virtualisation.docker.enable "docker")
    #     ++ (lib.optional config.virtualisation.libvirtd.enable "libvirtd")
    #     ;
    #   initialPassword = username;
    # };
    # users.groups.${username} = { };
  })
  # </isNixos>
  (lib.optionalAttrs isDarwin {
    my.home = { ... }: {
      home.homeDirectory = lib.mkForce "/Users/${username}"; # hmm...
    };
  })

  {
    my.home = { ... }: {
      my.identity = {
        name = "Niklas Voss";
        email = "niklas.voss@engelvoelkers.com";
        gpgSigningKey = "TODO";
      };
    };
  }
]
