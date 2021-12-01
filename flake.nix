{
  description = "My dotfiles that I copied together from everywhere...";

  inputs = {
    nixos-hardware.url = "nixos-hardware/master";
    nixpkgs.url = "nixpkgs/21.11";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/nur";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
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
          profiles = import ./profiles { inherit (self) isLinux; };
          isLinux = self.isLinux;
          isDarwin = !self.isLinux;
          # This could import the whole tree if evaluated?, including ignored files?
          rootPath = ./.;
        } // extraArgs;
      in
      lib.fix args;

    mkConfig = { hostname, username, isLinux,
      hostConfiguration ? ./hosts + "/${hostname}.nix",
      userConfiguration ? ./users + "/${username}.nix",
      extraModules ? [ ]
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
            isLinux = isLinux;
            isDarwin = !isLinux;
            inputs = inputs; # Inject inputs
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

    mkLinuxConfig = { platform, ... } @ args:
      let
        modules = mkConfig ((removeAttrs args [ "platform" ]) // { isLinux = true; });

        linuxDefaults = { pkgs, lib, ... }: {
          imports = [ inputs.home-manager.nixosModules.home-manager ];

          networking.hostName = lib.mkDefault args.hostname;

          system.nixos.tags = [ "with-flakes" ];
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
            isLinux = true;
          };
        };

    mkDarwinConfig = { platform, ... } @ args:
      let
        modules = mkConfig ((removeAttrs args [ "platform" ]) // { isLinux = false; });
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
        inputs.darwin.lib.darwinSystem {
          modules = modules ++ [ darwinDefaults ];
          inputs.nixpkgs = nixpkgs;
          system = platform;
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
        platform = "x86_64-darwin";
        hostConfiguration = ./hosts/darwin.nix;
      };
    };

    nixosConfigurations = {
      vm = mkLinuxConfig {
        hostname = "nixos";
        username = "nik";
        platform = "x86_64-linux";
        hostConfiguration = ./hosts/virtualbox.nix;
      };
      pulse = mkLinuxConfig {
        hostname = "pulse";
        username = "nik";
        platform = "x86_64-linux";
      };
    };

    overlays = let
      overlayFiles' = lib.filter (lib.hasSuffix ".nix") (lib.attrNames (builtins.readDir ./overlays));
      overlayFiles = lib.listToAttrs (map (name: {
        name = lib.removeSuffix ".nix" name;
        value = import (./overlays + "/${name}");
      }) overlayFiles');
    in overlayFiles // {
      nur = final: prev: {
        nur = import inputs.nur { nurpkgs = final; pkgs = final; };
      };
      unstable = let
        config = { allowUnfree = true; };
      in final: prev: {
        unstable = import inputs.nixpkgs-unstable { inherit (prev) system; inherit config; };
        # let's setup everything for vim/neovim to use unstable
        vim = final.unstable.vim;
        vimUtils = final.unstable.vimUtils;
        vimPlugins = final.unstable.vimPlugins;
        neovim-unwrapped = final.unstable.neovim-unwrapped;
        neovimUtils = final.unstable.neovimUtils;
        wrapNeovimUnstable = final.unstable.wrapNeovimUnstable;
        # newest terraform
        terraform_1_0 = final.unstable.terraform_1_0;
        # up-to-date language servers
        gopls = final.unstable.gopls;
        terraform-ls = final.unstable.terraform-ls;
        rnix-lsp = final.unstable.rnix-lsp;
      };
    };
  };
}
