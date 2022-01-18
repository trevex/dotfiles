{ config, options, lib, pkgs, isLinux, isHomeConfig, inputs, ... }:

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
  options.my = {
    username = mkOption {
      type = types.str;
      description = "Primary user username";
      example = "nik";
      readOnly = true;
    };
    home =
      if !isHomeConfig then
        mkOption { type = options.home-manager.users.type.functor.wrapped; }
      else # TODO: below does not work, so all profiles have to be aware whether they are run under HM or not :/
        let
          extendedLib = import "${inputs.home-manager}/modules/lib/stdlib-extended.nix" pkgs.lib;
          hmModules =
            import "${inputs.home-manager}/modules/modules.nix" { inherit pkgs; lib = extendedLib; };
          rawModule = extendedLib.evalModules { modules = hmModules; };
          hmModule = types.submoduleWith { modules = hmModules; };
        in
        mkOption { type = hmModule; };

  };

  config =
    if isHomeConfig then { } else {
      home-manager.users.${config.my.username} = mkAliasDefinitions options.my.home;
    } // {

      my.home = { ... }: {
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
