{ pkgs, config, lib, ... }:
let
  xkbCustomLayout = pkgs.writeText "xkb-layout" ''
    ! sudo showkey revealed, different keycodes than expected, so let's remap media keys
    keycode 114 = XF86AudioLowerVolume
    keycode 115 = XF86AudioRaiseVolume
  '';
in
{
  my = {
    username = "nik";
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      opengl.enable = true;
      printing.enable = true;
    };
    desktop = {
      bspwm.enable = true;
      term = {
        alacritty.enable = true;
      };
      browser = {
        chromium.enable = true;
      };
    };
    editors = {
      default = "nvim";
      neovim.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      zsh.enable = true;
    };
    services = {
      docker.enable = true;
    };
  };

  hardware.tuxedo-keyboard.enable = true;
  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "amdgpu" ];
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/b1c5179c-f1fc-4930-87d6-b43f2bfc3545";
    preLVM = true;
    allowDiscards = true;
  };

  # boot.kernelModules = [ "kvm-amd" ];
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

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;
  networking.networkmanager.enable = true;

  networking.enableIPv6 = false;
  boot.kernel.sysctl."net.ipv6.conf.wlp1s0.disable_ipv6" = true;

  time.timeZone = "Europe/Amsterdam";

  # services.xserver.dpi = 90;

  # Fix media keys
  services.xserver.displayManager.sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap ${xkbCustomLayout}";
  services.xserver.exportConfiguration = true;

  services.xserver.videoDrivers = [ "amdgpu" ];
}
