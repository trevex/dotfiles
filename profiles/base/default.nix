{ config, lib, pkgs, isLinux, isDarwin, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    ripgrep
    curl
    exa
    git
    git-lfs
    gcc
    bat
    moreutils
    tree
    gnumake
    unzip
    protobuf
    htop
  ];

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      material-design-icons
      (nerdfonts.override { fonts = [ "Meslo" ]; })
    ];
  } // (if isLinux then {
    fontDir.enable = true;
  } else {
    enableFontDir = true;
  });

  programs.zsh = {
    enable = true;
    enableCompletion = false; # we are using home-manager zsh, so do not enable!
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  my.home = {
    home.packages = with pkgs; [
      httpie
      kubectl
      krew
      kubernetes-helm
      google-cloud-sdk
      kubectx
      terraform_1_0
      terragrunt_0_31
      tfsec
    ];

    home.sessionVariables = {
      TF_PLUGIN_CACHE_DIR = "$HOME/.terraform.d/plugin-cache";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    programs.go = {
      enable = true;
      goPath = "Development/go";
      goBin = "Development/go/bin";
    };

    # TODO: use environment.shellInit?
    programs.zsh.initExtra = ''
      export PATH="$PATH:$GOBIN"
    '';

  };
}
