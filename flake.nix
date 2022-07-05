{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/22.05";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, ... }:
    let
      inherit (mylib) mapModules mapModulesRec mapHosts mapHomes;

      system = "x86_64-linux";

      mkPkgs = pkgs: overlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = overlays;
      };
      pkgs = mkPkgs nixpkgs (lib.attrValues self.overlays);
      pkgs' = mkPkgs nixpkgs-unstable [ ];

      lib = nixpkgs.lib;
      mylib = import ./lib { inherit pkgs inputs lib; };

      overlay =
        final: prev: {
          unstable = pkgs';
          my = self.packages."${system}";
        };
    in
    {
      overlays = # TODO: overlays available by modules?
        { default = overlay; } // mapModules ./overlays import;

      packages."${system}" =
        mapModules ./packages (p: pkgs.callPackage p { });

      nixosModules =
        { dotfiles = import ./.; } // mapModulesRec ./modules import;

      nixosConfigurations =
        mapHosts ./hosts { };

      homeConfigurations =
        mapHomes ./homes { };
    };
}
