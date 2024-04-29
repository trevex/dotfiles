{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

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
      };
    };
    shell = {
      zsh.enable = true;
      yubikey.enable = true;
    };
    services = {
      docker.enable = true;
    };
  };
  # Let's also setup and enable some home-manager modules
  my.home = { ... }: {
    my = {
      term = {
        alacritty = {
          enable = true;
          fontSize = 10.0;
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
        zsh.enable = true;
        direnv.enable = true;
      };
    };
  };

  time.timeZone = "Europe/Amsterdam";
}
