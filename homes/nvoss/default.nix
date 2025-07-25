{ config, pkgs, ... }:
{
  my = {
    nixGL.enable = true;
    term = {
      alacritty.enable = true;
    };
    editors = {
      neovim.enable = true;
      helix.enable = false;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      zsh.enable = true;
      kubectl.enable = true;
    };
  };

  home.packages = with pkgs; [
    # TODO: move "base"
    vim
    git
    git-lfs
    ripgrep
    curl
    eza
    gcc
    bat
    moreutils
    tree
    gnumake
    unzip
    htop
    fd
    dig
    wget
    openssl
    tokei
    httpie
    # TODO: move fonts
    dejavu_fonts
    material-design-icons
    apple-fonts
    nerd-fonts.meslo-lg
    # misc
    signal-desktop
  ];

  fonts.fontconfig.enable = true;

  home.sessionVariables = { LD_PRELOAD = "/usr/lib/x86_64-linux-gnu/libnss_cache.so.2"; };
  systemd.user.sessionVariables = { LD_PRELOAD = "/usr/lib/x86_64-linux-gnu/libnss_cache.so.2"; };
}
