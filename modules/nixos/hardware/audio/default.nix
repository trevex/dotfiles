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
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      media-session.config.bluez-monitor.rules = [
        {
          # Matches all cards
          matches = [{ "device.name" = "~bluez_card.*"; }];
          actions = {
            "update-props" = {
              # Do not use alsa-card-profiles, but try ucm instead.
              # See: https://wiki.archlinux.org/title/PipeWire#Bluetooth_devices
              # "api.alsa.use-acp" = false;
              # "api.alsa.use-ucm" = true;
              "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
              # mSBC is not expected to work on all headset + adapter combinations.
              "bluez5.msbc-support" = true;
              # SBC-XQ is not expected to work on all headset + adapter combinations.
              "bluez5.sbc-xq-support" = true;
              # Make sure to swap properly between A2DP and HSP/HFP
              "bluez5.autoswitch-profile" = true;
            };
          };
        }
        {
          matches = [
            # Matches all sources
            { "node.name" = "~bluez_input.*"; }
            # Matches all outputs
            { "node.name" = "~bluez_output.*"; }
          ];
          actions = {
            "node.pause-on-idle" = false;
          };
        }
      ];
    };

    # We still need pactl for some scripts
    environment.systemPackages = with pkgs; [
      pulseaudio
      pavucontrol
    ];

    my.user.extraGroups = [ "audio" ];
  };
}
