{ config, lib, pkgs, modulesPath, profiles, ... }:

{
  imports = with profiles; [ base neovim alacritty zsh bspwm ];

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/01a39f25-83e2-45a3-be06-14977b791595";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/308ba4b5-c2fc-46ba-880b-e4b8d306549f"; }
    ];

  virtualisation.virtualbox.guest.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  time.timeZone = "Europe/Amsterdam";

  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  system.stateVersion = "21.05";
}
