{
  description = "My dotfiles that I copied together from everywhere...";

  inputs = {
    nixos-hardware.url = "nixos-hardware/master";
    nixpkgs.url = "nixpkgs/22.05";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/nur";
    };
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , ...
    }:
    let
      inherit (nixpkgs) lib;

      # TODO: use flake-utils instead?
      platforms = [ "x86_64-linux" "x86_64-darwin" ];

      forAllPlatforms = f: lib.genAttrs platforms (platform: f platform);

      nixpkgsFor = forAllPlatforms (platform: import nixpkgs {
        system = platform;
        overlays = builtins.attrValues self.overlays;
        config.allowUnfree = true;
      });

      specialArgs = extraArgs:
        let
          args = self: {
            profiles = import ./profiles { inherit (self) isNixos isDarwin isHomeManager; };
            isNixos = self.isNixos;
            isDarwin = self.isDarwin;
            isHomeManager = self.isHomemanager;
            # This could import the whole tree if evaluated?, including ignored files?
            rootPath = ./.;
          } // extraArgs;
        in
        lib.fix args;

      mkConfig = # Helper only used by mkNixosConfig and mkDarwinConfig
        { hostname
        , username
        , isNixos
        , hostConfiguration ? ./hosts + "/${hostname}.nix"
        , userConfiguration ? ./users + "/${username}.nix"
        , extraModules ? [ ]
        }:
        let
          defaults = { config, pkgs, lib, ... }: {
            imports = [ hostConfiguration userConfiguration ];

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
              isNixos = isNixos;
              isDarwin = !isNixos;
              isHomeManager = false; # Not used by home-manager configs
              inputs = inputs; # Inject inputs
              rootPath = ./.;
            };
            home-manager.sharedModules = [
              {
                # Specify home-manager version compability
                home.stateVersion = "22.05";
                # Use the new systemd service activation/deactivation tool
                # See https://github.com/nix-community/home-manager/pull/1656
                systemd.user.startServices = "sd-switch";
              }
            ];

          };
        in
        [ ./module.nix defaults ] ++ extraModules;

      mkNixosConfig = { platform, ... } @ args:
        let
          modules = mkConfig ((removeAttrs args [ "platform" ]) // { isNixos = true; });

          linuxDefaults = { pkgs, lib, ... }: {
            imports = [ inputs.home-manager.nixosModules.home-manager ];

            networking.hostName = lib.mkDefault args.hostname;

            system.nixos.tags = [ "with-flakes" ];
            system.stateVersion = "22.05";
            nix = {
              # Pin nixpkgs for older Nix tools
              nixPath = [ "nixpkgs=${pkgs.path}" ];
              allowedUsers = [ "@wheel" ];
              trustedUsers = [ "root" "@wheel" ];

              registry = {
                self.flake = inputs.self;
                nixpkgs.flake = inputs.nixpkgs;
              };

              # Optimize (hardlink duplicates) store automatically
              autoOptimiseStore = true;
            };
          };
        in
        lib.nixosSystem {
          modules = [ linuxDefaults ] ++ modules;
          system = platform;
          pkgs = nixpkgsFor.${platform};
          specialArgs = specialArgs {
            inherit inputs;
            isNixos = true;
            isDarwin = false;
            isHomeManager = false;
          };
        };

      mkDarwinConfig = { platform, ... } @ args:
        let
          modules = mkConfig ((removeAttrs args [ "platform" ]) // { isNixos = false; });
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
              "darwin" + toString config.system.stateVersion + "." + inputs.darwin.shortRev
            );
            system.darwinRevision = inputs.darwin.rev;
            system.nixpkgsVersion =
              "${nixpkgs.lastModifiedDate or nixpkgs.lastModified}.${nixpkgs.shortRev}";
            system.nixpkgsRelease = lib.version;
            system.nixpkgsRevision = nixpkgs.rev;
          };
        in
        inputs.darwin.lib.darwinSystem {
          modules = modules ++ [ darwinDefaults ];
          inputs.nixpkgs = nixpkgs;
          system = platform;
          specialArgs = specialArgs {
            inputs = inputs // { darwin = inputs.darwin; };
            isNixos = false;
            isDarwin = true;
            isHomeManager = false;
          };
        };

      mkHomeManagerConfig =
        { hostname
        , platform
        , username
        , homeDir ? /home + "/${username}"
        , hostConfiguration ? ./hosts + "/${hostname}.nix"
        , userConfiguration ? ./users + "/${username}.nix"
        , extraModules ? [ ]
        }:
        let
          defaults = { config, pkgs, lib, ... }: {
            imports = [ hostConfiguration userConfiguration ];
            programs.home-manager.enable = true;
            xdg.enable = true;
            xdg.mime.enable = true;
            targets.genericLinux.enable = true;
            home.sessionVariables = {
              EDITOR = "nvim";
              BROWSER = "google-chrome";
              TERMINAL = "alacritty";
            };
            pam.sessionVariables = config.home.sessionVariables // {
              LANGUAGE = "en_US:en";
              LANG = "en_US.UTF-8";
            };
          };
          configuration = { pkgs, ... }: {
            nixpkgs.overlays = builtins.attrValues self.overlays;
            imports = [ ];
          };
        in
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit configuration;
          system = platform;
          homeDirectory = homeDir;
          username = username;
          extraModules = [ ./module.nix defaults ] ++ extraModules;
          extraSpecialArgs = specialArgs {
            isNixos = false;
            isDarwin = false;
            isHomeManager = true;
            inputs = inputs; # Inject inputs
          };
          stateVersion = "22.05";
        };
    in
    {
      darwinConfigurations = {
        CHG0332 = mkDarwinConfig {
          hostname = "CHG0332.local";
          username = "vossni";
          platform = "x86_64-darwin";
          hostConfiguration = ./hosts/darwin.nix;
        };
      };

      nixosConfigurations = {
        vm = mkNixosConfig {
          hostname = "nixos";
          username = "nik";
          platform = "x86_64-linux";
          hostConfiguration = ./hosts/virtualbox.nix;
        };
        pulse = mkNixosConfig {
          hostname = "pulse";
          username = "nik";
          platform = "x86_64-linux";
        };
      };

      homeConfigurations = {
        x1c = mkHomeManagerConfig {
          hostname = "x1c";
          username = "nvoss";
          platform = "x86_64-linux";
        };
      };

      overlays =
        let
          overlayFiles' = lib.filter (lib.hasSuffix ".nix") (lib.attrNames (builtins.readDir ./overlays));
          overlayFiles = lib.listToAttrs (map
            (name: {
              name = lib.removeSuffix ".nix" name;
              value = import (./overlays + "/${name}");
            })
            overlayFiles');
        in
        overlayFiles // {
          nur = final: prev: {
            nur = import inputs.nur { nurpkgs = final; pkgs = final; };
          };
          unstable =
            let
              config = { allowUnfree = true; };
            in
            final: prev: {
              unstable = import inputs.nixpkgs-unstable { inherit (prev) system; inherit config; };
              # let's setup everything for vim/neovim to use unstable
              vim = final.unstable.vim;
              vimUtils = final.unstable.vimUtils;
              vimPlugins = final.unstable.vimPlugins;
              neovim-unwrapped = final.unstable.neovim-unwrapped;
              neovimUtils = final.unstable.neovimUtils;
              wrapNeovimUnstable = final.unstable.wrapNeovimUnstable;
              # newest terraform
              terraform_1 = final.unstable.terraform_1;
              # up-to-date language servers
              gopls = final.unstable.gopls;
              terraform-ls = final.unstable.terraform-ls;
              rnix-lsp = final.unstable.rnix-lsp;
            };
        };
    };
}
