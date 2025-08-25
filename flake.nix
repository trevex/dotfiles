{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:rycee/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixgl.url = "github:guibou/nixGL";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, ... }:
    let
      inherit (mylib) mapModules mapModulesRec mapHosts mapHomes;

      system = "x86_64-linux";

      mkPkgs = pkgs: overlays: import pkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
      pkgs = mkPkgs nixpkgs (lib.attrValues self.overlays);
      pkgs' = mkPkgs nixpkgs-unstable [ ];

      lib = nixpkgs.lib;
      mylib = import ./lib { inherit pkgs inputs lib; };

      overlay =
        final: prev: {
          unstable = pkgs';
          my = self.packages."${system}";
        } // (import ./overlays { inherit inputs; }) final prev // inputs.nixgl.overlay final prev;
    in
    {
      overlays.default = overlay;

      packages."${system}" =
        mapModules ./packages (p: pkgs.callPackage p { inherit inputs; });

      nixosModules =
        { dotfiles = import ./.; } // mapModulesRec ./modules import;

      nixosConfigurations =
        mapHosts ./hosts { };

      homeConfigurations =
        mapHomes ./homes { };
    };
}
