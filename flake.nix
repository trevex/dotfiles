{
  description = "A very basic flake";

  inputs = {
    nixos-hardware.url = "nixos-hardware/master";
    nixpkgs.url = "nixpkgs/21.05";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs @ {
    self,
    nixos-hardware,
    nixpkgs,
    darwin,
    home-manager,
    flake-utils,
    nur
  }: (flake-utils.lib.eachDefaultSystem (system:
  let
      inherit (nixpkgs) lib;

      specialArgs = extraArgs:
        let
          args = self: {
            profiles = import ./profiles { inherit (self) isLinux; };
            isLinux = self.isLinux;
            isDarwin = !self.isLinux;
            # This could import the whole tree if evaluated?, including ignored files?
            rootPath = ./.;
          } // extraArgs;
        in
        lib.fix args;

      mkConfig = { hostname, username, isLinux,
        hostConfiguration ? "./hosts/${hostname}.nix",
        userConfiguration ? "./users/${username}.nix",
        extraModules ? [ ]
      }:
        let
          defaults = { config, pkgs, lib, ... }: {
            imports = [ hostConfiguration userConfiguration ];

            environment.systemPackages = [];

            networking.hostName = lib.mkDefault hostname;

            nixpkgs.config.allowUnfree = true;
            nix = {
              package = pkgs.nixFlakes;
              extraOptions = ''
                experimental-features = nix-command flakes
              '';
            };

            # My custom user settings
            my = { inherit username; };

            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              verbose = true;
            };
            home-manager.extraSpecialArgs = {
              isLinux = isLinux;
              isDarwin = !isLinux;
              # Inject inputs
              inputs = inputs;
              rootPath = ./.;
            };
            home-manager.sharedModules = [
              {
                # Specify home-manager version compability
                home.stateVersion = "21.05";
                # Use the new systemd service activation/deactivation tool
                # See https://github.com/nix-community/home-manager/pull/1656
                systemd.user.startServices = "sd-switch";
              }
            ];
          };
        in [ ./module.nix defaults ] ++ extraModules;

      mkDarwinConfig = args:
        let
          modules = mkConfig (args // { isLinux = false; });
          nixpkgs = inputs.nixpkgs;

          darwinDefaults = { config, pkgs, lib, ... }: {
            imports = [ inputs.home-manager.darwinModules.home-manager ];
            nix.gc.user = args.username;
            nix.nixPath = [
              "nixpkgs=${pkgs.path}"
              "darwin=${inputs.darwin}"
            ];
            # The Darwin module wraps the nixpkgs input itself for some reason...
            nixpkgs.overlays = builtins.attrValues self.overlays;
            system.checks.verifyNixPath = false;
            system.darwinVersion = lib.mkForce (
              "darwin" + toString config.system.stateVersion + "." + inputs.darwin.shortRev);
            system.darwinRevision = inputs.darwin.rev;
            system.nixpkgsVersion =
              "${nixpkgs.lastModifiedDate or nixpkgs.lastModified}.${nixpkgs.shortRev}";
            system.nixpkgsRelease = lib.version;
            system.nixpkgsRevision = nixpkgs.rev;
          };
        in
          inputs.nix-darwin.lib.darwinSystem {
            modules = modules ++ [ darwinDefaults ];
            inputs.nixpkgs = nixpkgs;
            specialArgs = specialArgs {
              inputs = inputs // { darwin = inputs.darwin; };
              isLinux = false;
            };
          };
    in
    {
      darwinConfigurations = {
        CHG0332 = mkDarwinConfig {
          hostname = "CHG0332.local";
          username = "vossni";
        };
      };
    }
  ));
}