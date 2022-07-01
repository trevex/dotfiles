{ config, options, lib, home-manager, ... }:

with lib;
with lib.my;
{
  options.my = with types; {
    username = mkOption {
      type = types.str;
      description = "Primary username";
      example = "nik";
    };

    user = mkOpt attrs { };

    home = # mkOpt attrs instead?
      mkOption { type = options.home-manager.users.type.functor.wrapped; };

    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs
        (n: v:
          if isList v
          then concatMapStringsSep ":" (x: toString x) v
          else (toString v));
      default = { };
      description = "Environment variables to be set";
    };
  };

  config =
    let
      inherit (config.my) username;
    in
    {
      home-manager = {
        useUserPackages = true; # Install user packes to /etc/profiles instead
        users.${username} = mkAliasDefinitions options.my.home;
      };
      my.home = {
        home.stateVersion = config.system.stateVersion;
      };
      my.user = {
        createHome = true;
        isNormalUser = true;
        uid = 1000;
        group = username;
        home = "/home/${username}";
        extraGroups = [ "wheel" "networkmanager" "input" "video" "dialout" ];
        initialPassword = "nixos";
      };
      users.users.${username} = mkAliasDefinitions options.my.user;
      users.users.root.initialPassword = "nixos";
      users.groups.${username} = { };

      security.sudo.extraRules = [
        {
          users = [ username ];
          commands = [
            { command = "ALL"; options = [ "NOPASSWD" ]; }
          ];
        }
      ];

      nix.settings = let users = [ "root" username ]; in
        {
          trusted-users = users;
          allowed-users = users;
        };

      # must already begin with pre-existing PATH. Also, can't use binDir here,
      # because it contains a nix store path.
      my.env.PATH = [ "$XDG_BIN_HOME" "$PATH" ];

      environment.extraInit =
        concatStringsSep "\n"
          (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.my.env);
    };
}
