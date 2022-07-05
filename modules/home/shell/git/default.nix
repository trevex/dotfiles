{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.my.shell.git;
in
{
  options.my.shell.git = {
    enable = mkBoolOpt false;
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
}
