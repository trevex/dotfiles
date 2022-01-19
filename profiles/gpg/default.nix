{ config, pkgs, ... }:
{
  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
