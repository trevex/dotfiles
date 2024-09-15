{ config, options, lib, pkgs, mylib, ... }:

with lib;
with mylib;
let cfg = config.my.shell.gnupg;
in
{
  options.my.shell.gnupg = with types; {
    enable = mkBoolOpt false;
    cacheTTL = mkOpt int 3600; # 1hr
  };

  config = mkIf cfg.enable {
    # environment.shellInit = ''
    #   export GPG_TTY="$(tty)"
    #   export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    #   gpgconf --launch gpg-agent
    # '';

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # HACK Without this config file you get "No pinentry program" on 20.03.
    #      programs.gnupg.agent.pinentryFlavor doesn't appear to work, and this
    #      is cleaner than overriding the systemd unit.
    # my.home = {
    #   xdg.configFile."gnupg/gpg-agent.conf" = {
    #     text = ''
    #       default-cache-ttl ${toString cfg.cacheTTL}
    #       pinentry-program ${pkgs.pinentry.gtk2}/bin/pinentry
    #     '';
    #   };
    # };
  };
}
