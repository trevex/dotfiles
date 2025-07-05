{ options, config, lib, pkgs, mylib, ... }:

with lib;
with mylib;
let cfg = config.my.hardware.audio;
in
{
  options.my.hardware.audio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # We still need pactl for some scripts
    environment.systemPackages = with pkgs; [
      pulseaudio
      pavucontrol
    ];

    my.user.extraGroups = [ "audio" ];
  };
}
