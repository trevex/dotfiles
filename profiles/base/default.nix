{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    ripgrep
    curl
    git
    git-lfs
    gcc
    bat
    moreutils
  ];

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      dejavu_fonts
      material-design-icons
      (nerdfonts.override { fonts = [ "Meslo" ]; })
    ];
  };

  programs.zsh.enable = true;  # default shell on catalina

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
  };
}
