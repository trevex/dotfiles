# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, profiles, ... }:

{
  imports = with profiles; [
    base
    neovim
    alacritty
    zsh
    bspwm
    polybar
    rofi
    dunst
    desktop
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/b1c5179c-f1fc-4930-87d6-b43f2bfc3545";
    preLVM = true;
    allowDiscards = true;
  };

  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [
    "acpi_backlight=vendor"
    "video.use_native_backlight=1"
  ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/2f3f7b6b-9d32-4b9d-8867-6030fe234e16";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };


  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3551-8964";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/25aa0ebc-d461-4541-bca1-25942fd85314"; }
    ];

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  # services.xserver.dpi = 90;
}
