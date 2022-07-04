{ config, options, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.my.shell.zsh;
  inherit (pkgs) stdenv;
in
{
  options.my.shell.zsh = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;
    my.user.shell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = false; # we are using home-manager zsh, so do not enable!
    };

    my.home = { ... }: {
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.zsh = {
        enable = true;
        zplug = {
          enable = true;
          plugins = [
            { name = "zsh-users/zsh-syntax-highlighting"; tags = [ "defer:2" ]; }
            { name = "plugins/git"; tags = [ "from:oh-my-zsh" ]; }
            { name = "plugins/kubectl"; tags = [ "from:oh-my-zsh" ]; }
            { name = "plugins/helm"; tags = [ "from:oh-my-zsh" ]; }
            { name = "plugins/docker"; tags = [ "from:oh-my-zsh" ]; }
            { name = "plugins/cp"; tags = [ "from:oh-my-zsh" ]; }
            { name = "plugins/man"; tags = [ "from:oh-my-zsh" ]; }
          ];
        };
        history = {
          save = 10000000;
          size = 10000000;
        };
        shellAliases = {
          ls = if stdenv.isLinux then "ls --color" else "ls -G";
          cddev = "cd ~/Development";
          watch = "watch ";
          vim = "nvim";
          gpgbye = "gpg-connect-agent updatestartuptty /bye";
          tmux = "tmux -u";
          kush = "kubectl run ubuntu --rm -i --tty --image ubuntu -- bash";
          kctx = "kubectx"; # TODO: move where relevant
          kns = "kubens";
          tf = "terraform";
          tg = "terragrunt";
        };
        initExtra = ''
          # Disable the underline for paths
          typeset -A ZSH_HIGHLIGHT_STYLES
          ZSH_HIGHLIGHT_STYLES[path]='none'

          autoload -z edit-command-line
          zle -N edit-command-line
          bindkey "^X^X" edit-command-line
          bindkey '^A' beginning-of-line
          bindkey '^E' end-of-line

          setopt PROMPT_SP

          # Make sure krew works
          export PATH="$PATH:$HOME/.krew/bin"
        '';
      };

      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        # Configuration written to ~/.config/starship.toml
        settings = {
          # add_newline = false;

          # character = {
          #   success_symbol = "[➜](bold green)";
          #   error_symbol = "[➜](bold red)";
          # };

          golang.symbol = " ";
          docker_context.symbol = " ";
          directory.read_only = " ";
          aws.symbol = "  ";
          git_branch.symbol = " ";
          java.symbol = " ";
          memory_usage.symbol = " ";
          nix_shell.symbol = " ";
          package.symbol = " ";
          python.symbol = " ";
          rust.symbol = " ";
          shlvl.symbol = " ";
          gcloud.symbol = " ";
          terraform.symbol = "行";
          lua.symbol = " ";
        };
      };

    };
  };
}