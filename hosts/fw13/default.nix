{
  pkgs,
  basePkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
  boot.kernelParams = [
    "amdgpu.sg_display=0"
    "amdgpu.dcdebugmask=0x10" # mitigate DMCUB fault → CRTC flip_done timeout on Ryzen APU
  ];

  # Pull the newer AMD Phoenix MES blobs from unstable's linux-firmware, fw13
  # only. Targets amdgpu MES scheduler hangs (ring comp/gfx timeouts → MODE2 GPU
  # resets) on the Ryzen APU. Overriding the package (rather than appending to
  # hardware.firmware) makes enableRedistributableFirmware pull the new blob and
  # avoids firmware-file collisions. Requires a cold power-cycle to take effect —
  # the blob is only re-uploaded to the GPU on cold init.
  #
  # mkHost wires nixpkgs.pkgs to an externally-built instance, which forbids a
  # system-level nixpkgs.overlays; and the module-arg `pkgs` *is* nixpkgs.pkgs,
  # so extending it here would self-reference. basePkgs is that same overlaid
  # instance delivered via specialArgs (a plain value), so extending it breaks
  # the cycle. `unstable` is already present on it from overlays.default.
  nixpkgs.pkgs = lib.mkForce (
    basePkgs.extend (
      final: prev: {
        linux-firmware = final.unstable.linux-firmware;
      }
    )
  );

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
      libvirtd.enable = true;
      tailscale.enable = true;
    };
  };
  # ProtonVPN TODO: modularize
  networking.firewall.checkReversePath = false;
  services.netbird.enable = true; # for netbird service & CLI
  environment.systemPackages = with pkgs; [
    wireguard-tools
    protonvpn-gui
    netbird-ui
  ];
  # Configure nix-flatpak
  services.flatpak = {
    enable = true;
    packages = [
      "org.jdownloader.JDownloader"
    ];
  };

  # Let's also setup and enable some home-manager modules
  my.home = { ... }: {
    # Disable GNOME's ambient-light auto-brightness. The Framework 13 ALS
    # otherwise dims/brightens the panel on its own as room light changes.
    dconf.settings."org/gnome/settings-daemon/plugins/power".ambient-enabled = false;

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
      unstable.glab
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
