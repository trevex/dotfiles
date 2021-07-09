{ config, pkgs, ... }:
{
  imports = [ <home-manager/nix-darwin> ];

  # TODO: yabai, skhd

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    ripgrep
  ];

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      dejavu_fonts
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Use /etc/profiles instead of $HOME/.nix-profile
  home-manager.useUserPackages = true;
  # Use global `pkgs` to save an extra Nixpkgs evaluation, adds consistency
  home-manager.useGlobalPkgs = true;
  # Add overlays and packages
  nixpkgs.overlays = [ (import ./pkgs) ];

  home-manager.users.vossni = import ./home;
}
