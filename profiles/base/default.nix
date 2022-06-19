# Expected to be used with mkProfile (see ../default.nix).
{ config, lib, pkgs, isNixos, isDarwin, isHomeManager, ... }:
let
  fontPackages = with pkgs; [
    dejavu_fonts
    material-design-icons
    (nerdfonts.override { fonts = [ "Meslo" ]; })
  ];
  systemPackages = with pkgs; [
    vim
    git
    git-lfs
    ripgrep
    curl
    exa
    gcc
    bat
    moreutils
    tree
    gnumake
    unzip
    protobuf
    htop
    fd
    dig
    wget
    openssl
  ];
  home = {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      httpie
      kubectl
      krew
      kubernetes-helm
      google-cloud-sdk
      kubectx
      terraform_1
      terragrunt_0_31
      tfsec
      grype
      tokei
      act
    ] ++ (if isHomeManager then fontPackages ++ systemPackages else [ ]);

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

    # https://github.com/nix-community/nix-direnv
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    # TODO: use environment.shellInit?
    programs.zsh.initExtra = ''
      export PATH="$PATH:$GOBIN"
    '';

    programs.git = {
      enable = true;
      lfs.enable = true;
      aliases = {
        a = "add";
        c = "commit";
        ca = "commit --amend";
        can = "commit --amend --no-edit";
        cl = "clone";
        cm = "commit -m";
        co = "checkout";
        cp = "cherry-pick";
        cpx = "cherry-pick -x";
        d = "diff";
        f = "fetch";
        fo = "fetch origin";
        fu = "fetch upstream";
        lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        pl = "pull";
        pr = "pull -r";
        ps = "push";
        psf = "push -f";
        rb = "rebase";
        rbi = "rebase -i";
        r = "remote";
        ra = "remote add";
        rr = "remote rm";
        rv = "remote -v";
        rs = "remote show";
        st = "status";
      };
      # TODO: set username and email in user part
      # userName = "Niklas Voss";
      # userEmail = "niklas.voss@gmail.com";
      # signing = {
      #   key = "";
      #   signByDefault = true;
      # };
      # Or use work sub-dir, e.g. https://github.com/jonringer/nixpkgs-config/blob/14626b49310d747a2a4d4c1e3fd62dedef4cb860/home.nix
    };
  };

in
if isHomeManager then home else
{
  environment.systemPackages = systemPackages;

  fonts = {
    fonts = fontPackages;
  } // (if isNixos then {
    fontDir.enable = true;
  } else {
    enableFontDir = true;
  });

  programs.zsh = {
    enable = true;
    enableCompletion = false; # we are using home-manager zsh, so do not enable!
  };

  my.home = home;
}
