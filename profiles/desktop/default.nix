{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dconf
    libnotify
    firefox # chrome is default and installed via home-manager below
    libva-utils
    ffmpeg-full
    font-manager
    slack
    mate.atril # default for pdf
    pdftk
    qpdf
    ghostscript
    vlc
    mkchromecast
    pavucontrol
  ];

  environment.etc."xdg/mimeapps.list" = {
    text = ''
      [Default Applications]
      application/pdf=atril.desktop;
    '';
  };

  # Some applications interact with power controls via DBus, e.g. Chromium
  services.upower.enable = true;

  # Configure OpenGL fo VA-API (encoding HW-accleration) and Vulkan
  hardware.opengl = {
    enable = true;
    driSupport = true; # for Vulkan
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      amdvlk # for Vulkan
    ];
  };

  # Configure printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  # Enable docker
  virtualisation.docker.enable = true;

  my.home = {
    services.network-manager-applet.enable = true;
    services.blueman-applet.enable = true;

    # Let's setup chromium and add our custom desktop item
    programs.chromium = {
      enable = true;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      ];
      # Chromium is not properly leveraging HW-acceleration, so let's make sure
      # to enable it by passing in the required flags.
      package = (pkgs.chromium.override {
        commandLineArgs = [
          "--enable-features=VaapiVideoDecoder"
          "--enable-gpu-rasterization"
          "--enable-zero-copy"
          "--ignore-gpu-blocklist"
        ];
      });
    };
  };

  # On every laptop we want to suspend once the lid is closed
  services.logind.lidSwitch = "suspend";
}
