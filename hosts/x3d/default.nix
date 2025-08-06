{ pkgs, config, lib, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./hardware-configuration.nix
  ];


  # nvidia
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # realtek driver
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # windows dual-boot
  time.hardwareClockInLocalTime = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.nik.hashedPassword = "$y$j9T$D2b0WHUb1BkJr7wIpX7LH0$vrTmyfrLdD4ct2Wr1QJnSUabaiEC3txQRzISRGmbe74";

  # Enable and configure relevant nixos modules
  my = {
    username = "nik";
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      opengl.enable = true;
      printing.enable = true;
    };
    desktop = {
      gnome.enable = true;
      browser = {
        chromium.enable = true;
        firefox.enable = true;
      };
    };
    shell = {
      gnupg.enable = true;
      zsh.enable = true;
    };
    services = {
      docker.enable = true;
    };
  };
  # Let's also setup and enable some home-manager modules
  my.home = { ... }: {
    home.packages = with pkgs; [
      teamspeak_client
      xclip
    ];

    my = {
      term = {
        alacritty = {
          enable = true;
          fontSize = 11.0;
        };
      };
      editors = {
        neovim.enable = true;
      };
      shell = {
        git = {
          enable = true;
          userName = "Niklas Voss";
          userEmail = "niklas.voss@gmail.com";
        };
        direnv.enable = true;
        zsh.enable = true;
      };
    };
  };

  time.timeZone = "Europe/Amsterdam";
}
