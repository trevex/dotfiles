{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "amdgpu.sg_display=0"
    "amdgpu.dcdebugmask=0x10" # mitigate DMCUB fault → CRTC flip_done timeout on Ryzen APU
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
        firefox.enable = true;
      };
    };
    shell = {
      zsh.enable = true;
      yubikey.enable = true;
      gnupg.enable = true;
    };
    services = {
      docker.enable = true;
      libvirtd.enable = false;
      tailscale.enable = true;
    };
  };
  # ProtonVPN TODO: modularize
  networking.firewall.checkReversePath = false;
  services.netbird.enable = true; # for netbird service & CLI
  environment.systemPackages = with pkgs; [ wireguard-tools protonvpn-gui netbird-ui ];
  # Configure nix-flatpak
  services.flatpak = {
    enable = true;
    packages = [
      "org.jdownloader.JDownloader"
      "im.riot.Riot"
    ];
  };

  # Let's also setup and enable some home-manager modules
  my.home = { ... }: {
    home.packages = with pkgs; [
      unstable.signal-desktop
      unstable.slack
      unstable.discord
      unstable.zoom-us
      unstable.kubefwd
      nixfmt-rfc-style # TODO: relevant everywhere?
      inkscape
      unstable.element-desktop
      unstable.gh
      unstable.github-copilot-cli
      claude-code # via overlay
    ];

    my = {
      term = {
        alacritty = {
          enable = true;
          fontSize = 10.0;
        };
      };
      editors = {
        neovim.enable = true;
        vscode.enable = true;
      };
      shell = {
        git = {
          enable = true;
          userName = "Niklas Voss";
          userEmail = "niklas.voss@gmail.com";
          includes = [
            {
              condition = "gitdir:~/Development/ace/";
              path = "~/Development/ace/.gitconfig";
            }
            {
              condition = "gitdir:~/Development/odp/";
              path = "~/Development/odp/.gitconfig";
            }
            {
              condition = "gitdir:~/Development/icn/";
              path = "~/Development/icn/.gitconfig";
            }
          ];
        };
        zsh.enable = true;
        direnv.enable = true;
        kubectl.enable = false; # TODO: broken...
      };
    };
  };

  time.timeZone = "Europe/Amsterdam";
  networking.networkmanager.wifi.backend = "iwd";
  networking.wireless.iwd.settings = {
    IPv6 = {
      Enabled = true;
    };
    Settings = {
      AutoConnect = true;
    };
  };
}
