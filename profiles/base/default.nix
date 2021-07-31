{ config, pkgs, ... }:
let
  inherit (pkgs) stdenv;
  devDirRelativeToHome = if stdenv.isLinux then "development" else "Development";
in
{
  environment.systemPackages = with pkgs; [
    vim
    ripgrep
    curl
    git
    gcc
    bat
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
      terraform_0_15
      terragrunt_0_29
    ];

    home.sessionVariables = {
      TF_PLUGIN_CACHE_DIR = "$HOME/.terraform.d/plugin-cache";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    programs.go = {
      enable = true;
      goPath = "${devDirRelativeToHome}/go";
      goBin = "${devDirRelativeToHome}/go/bin";
    };
  };
}
