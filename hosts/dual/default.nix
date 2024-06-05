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
