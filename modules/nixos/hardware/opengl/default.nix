{ options, config, lib, pkgs, mylib, ... }:

with lib;
with mylib;
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
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}
