{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.my.hardware.opengl;
in
{
  options.my.hardware.opengl = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libva-utils
      ffmpeg-full
      glxinfo
    ];

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
  };
}
