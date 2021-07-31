{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dconf
    libnotify
    firefox
  ];

  # Enable docker
  virtualisation.docker.enable = true;

  my.home = {
    services.network-manager-applet.enable = true;
  };

  # On every laptop we want to suspend once the lid is closed
  services.logind.lidSwitch = "suspend";
}
