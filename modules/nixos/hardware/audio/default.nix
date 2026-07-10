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

      # Disable WirePlumber's libcamera monitor. It aborts (SIGABRT) when it
      # enumerates a UVC webcam twice ("duplicated ID"), crash-looping the
      # session manager and dropping all audio sinks to "Dummy Output" until
      # systemd restarts it. The webcam still works via the V4L2 path.
      wireplumber.extraConfig."10-disable-libcamera" = {
        "wireplumber.profiles".main."monitor.libcamera" = "disabled";
      };
    };

    # We still need pactl for some scripts
    environment.systemPackages = with pkgs; [
      pulseaudio
      pavucontrol
    ];

    my.user.extraGroups = [ "audio" ];
  };
}
