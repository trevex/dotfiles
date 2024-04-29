{ config, options, lib, pkgs, mylib, ... }:

with lib;
with mylib;
let cfg = config.my.shell.git;
in
{
  options.my.shell.git = {
    enable = mkBoolOpt false;
    userName = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    userEmail = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
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
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      # signing = {
      #   key = "";
      #   signByDefault = true;
      # };
      # Or use work sub-dir, e.g. https://github.com/jonringer/nixpkgs-config/blob/14626b49310d747a2a4d4c1e3fd62dedef4cb860/home.nix
    };
  };
}
