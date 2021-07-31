{ config, lib, pkgs, isLinux, isDarwin, ... }:

let
  inherit (config.my) username;
in
lib.mkMerge [
  (lib.optionalAttrs isLinux {
    security.sudo.extraRules = [
      {
        users = [ username ];
        commands = [
          { command = "ALL"; options = [ "NOPASSWD" ]; }
        ];
      }
    ];
    users.users.${username} = {
      createHome = true;
      isNormalUser = true;
      shell = pkgs.zsh;
      uid = 1000;
      group = username;
      home = "/home/${username}";
      extraGroups = [ "wheel" "networkmanager" "input" "audio" "video" "dialout" ]
        ++ (lib.optional config.virtualisation.docker.enable "docker")
        ++ (lib.optional config.virtualisation.libvirtd.enable "libvirtd")
        ;
      initialPassword = username;
    };
    users.groups.${username} = { };

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };
  })
  # </isLinux>
  (lib.optionalAttrs isDarwin {
    my.home = { ... }: {
      home.homeDirectory = lib.mkForce "/Users/${username}"; # hmm...
    };
  })

  {
    my.home = { ... }: {
      my.identity = {
        name = "Niklas Voss";
        email = "niklas.voss@gmail.com";
        gpgSigningKey = "TODO";
      };
    };
  }
]
