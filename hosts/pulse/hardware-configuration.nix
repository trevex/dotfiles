{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  hardware.tuxedo-keyboard.enable = true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.opengl = {
    extraPackages = with pkgs; [
      amdvlk # for Vulkan on AMD
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  boot.loader.systemd-boot.enable = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "amdgpu" ];
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/b1c5179c-f1fc-4930-87d6-b43f2bfc3545";
    preLVM = true;
    allowDiscards = true;
  };
  boot.kernelParams = [
    "acpi_backlight=vendor"
    "video.use_native_backlight=1"
  ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/2f3f7b6b-9d32-4b9d-8867-6030fe234e16";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };
  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/3551-8964";
      fsType = "vfat";
    };
  swapDevices =
    [{ device = "/dev/disk/by-uuid/25aa0ebc-d461-4541-bca1-25942fd85314"; }];

  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;
  networking.enableIPv6 = false;
  boot.kernel.sysctl."net.ipv6.conf.wlp1s0.disable_ipv6" = true;
}
