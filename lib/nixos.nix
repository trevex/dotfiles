{ inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let
  sys = "x86_64-linux";
  defaults = {
    imports =
      # I use home-manager to deploy files to $HOME; little else
      [ inputs.home-manager.nixosModules.home-manager ]
      # All my personal modules
      ++ (mapModulesRec' (toString ../modules) import);

    # Configure nix and nixpkgs
    environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
    nix =
      let
        filteredInputs = filterAttrs (n: _: n != "self") inputs;
        nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
        registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
      in
      {
        package = pkgs.nixFlakes;
        extraOptions = "experimental-features = nix-command flakes";
        nixPath = nixPathInputs ++ [
          "nixpkgs-overlays=${builtins.toString ../overlays}"
          "dotfiles=${builtins.toString ../.}"
        ];
        allowedUsers = [ "@wheel" ];
        trustedUsers = [ "root" "@wheel" ];
        registry = registryInputs // { dotfiles.flake = inputs.self; };
        settings = {
          auto-optimise-store = true;
        };
      };
    system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
    system.stateVersion = "22.05";

    ## Some reasonable, global defaults
    # This is here to appease 'nix flake check' for generic hosts with no
    # hardware-configuration.nix or fileSystem config.
    # fileSystems."/".device = mkDefault "/dev/disk/by-label/nixos";

    # The global useDHCP flag is deprecated, therefore explicitly set to false
    # here. Per-interface useDHCP will be mandatory in the future, so we enforce
    # this default behavior here.
    networking.useDHCP = mkDefault false;
    # We use network-manager by default
    networking.networkmanager.enable = mkDefault true;

    # Use the latest kernel
    boot = {
      kernelPackages = mkDefault pkgs.linuxKernel.packages.linux_5_15;
      loader = {
        efi.canTouchEfiVariables = mkDefault true;
        # systemd-boot.configurationLimit = 10;
        systemd-boot.enable = mkDefault true;
      };
    };

    # Just the bear necessities...
    environment.systemPackages = with pkgs; [
      bind
      cached-nix-shell
      git
      vim
      wget
      gnumake
      unzip
    ];

    # On every laptop we want to suspend once the lid is closed
    services.logind.lidSwitch = "suspend";
  };
in
{
  mkHost = path: attrs @ { system ? sys, ... }:
    nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        defaults
        (import path)
      ];
    };

  mapHosts = dir: attrs @ { system ? system, ... }:
    mapModules dir
      (hostPath: mkHost hostPath attrs);
}
