export GOPATH=$HOME/Development/go
export PATH=$PATH:$GOPATH/bin
export VISUAL=nvim

# Load zplug
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# Enable vi-mode
bindkey -v

# Disable the underline for paths
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='none'

# Load plugins
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "junegunn/fzf", as:command, hook-build:"./install --bin", use:"bin/{fzf-tmux,fzf}"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/helm", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/cp", from:oh-my-zsh
zplug "plugins/man", from:oh-my-zsh

zplug load

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load fzf
source $ZPLUG_HOME/repos/junegunn/fzf/shell/key-bindings.zsh
source $ZPLUG_HOME/repos/junegunn/fzf/shell/completion.zsh

# Add keybinding to edit command-line via vim
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Setup yubikey for ssh
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# Some convenient aliases
alias watch='watch '
alias vim='nvim'
alias vims='NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim'
alias vimr='nvr --remote'
