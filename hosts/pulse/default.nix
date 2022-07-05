{ pkgs, config, lib, ... }:
let
  xkbCustomLayout = pkgs.writeText "xkb-layout" ''
    ! sudo showkey revealed, different keycodes than expected, so let's remap media keys
    keycode 114 = XF86AudioLowerVolume
    keycode 115 = XF86AudioRaiseVolume
  '';
in
{
  imports = [
    ./hardware-configuration.nix
  ];

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
      browser = {
        chromium.enable = true;
      };
    };
    shell = {
      zsh.enable = true;
    };
    services = {
      docker.enable = true;
    };
  };

  time.timeZone = "Europe/Amsterdam";

  # services.xserver.dpi = 90;

  # Fix media keys
  services.xserver.displayManager.sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap ${xkbCustomLayout}";
  services.xserver.exportConfiguration = true;

  services.xserver.videoDrivers = [ "amdgpu" ];
}
