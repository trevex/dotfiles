{ pkgs, lib, ... }:
let
  inherit (pkgs) stdenv;
  devDirRelativeToHome = if stdenv.isLinux then "development" else "Development";
in
{
  imports = [
    ./alacritty.nix
    ./zsh.nix
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    httpie
    kubectl
    krew
    kubernetes-helm
    google-cloud-sdk
    kubectx
    # language servers
    gopls
    terraform-ls
    rnix-lsp
  ];

  # TODO: setup git and aliases
  # TODO: import gpg public keys?

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
}
