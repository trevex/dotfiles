{ config, options, lib, isLinux, isHomeConfig, inputs, ... }:

with lib;

let
  filesInDir = directory:
    let
      files = builtins.readDir directory;
      filteredFiles = filterAttrs (n: v: hasSuffix "nix" n && n != "default.nix") files;
      toPath = map (x: directory + "/${x}");
    in
    assert builtins.isPath directory;
    toPath (attrNames filteredFiles);
in
{
  # imports = optionals isLinux (filesInDir ./modules/nixos);

  options.my = {
    username = mkOption {
      type = types.str;
      description = "Primary user username";
      example = "nik";
      readOnly = true;
    };
    home = if !isHomeConfig then mkOption {
      type = options.home-manager.users.type.functor.wrapped;
    } else {
	programs = mkOption { type = types.anything; };
	# programs = mkOption { type = hm.types.dagOf options.programs; };
	};
  };

  config = if isHomeConfig then {

    programs = mkAliasDefinitions options.my.home.programs;
} else {
    home-manager.users.${config.my.username} = mkAliasDefinitions options.my.home;
} // {

    my.home = { ... }:  {
      # imports = filesInDir ./modules/home-manager;

      options.my.identity = {
        name = mkOption {
          type = types.str;
          description = "Fullname";
        };
        email = mkOption {
          type = types.str;
          description = "Email";
        };
        gpgSigningKey = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Primary GPG signing key";
        };
      };
    };
  };

}
