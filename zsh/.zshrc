# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/nik/.oh-my-zsh"

# Default command for fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --smart-case --glob "!.git/*"'

# Fast vi-mode switching
export KEYTIMEOUT=10

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bureau"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  vi-mode
  git
  kubectl
  kube-ps1
  helm
  docker
  cp
  man
  fzf
  kubetail
)

source $ZSH/oh-my-zsh.sh

# User configuration
function _vi_mode() {
    if [ -z $(vi_mode_prompt_info ) ]; then
        echo ">"
    else
        echo "%{$fg_bold[red]%}<%{$reset_color%}"
    fi
}
PROMPT='$(_vi_mode) $_LIBERTY '
RPROMPT='$(kube_ps1)'$RPROMPT
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey -M viins "${terminfo[khome]}" beginning-of-line # Home key
bindkey -M viins "${terminfo[kend]}" end-of-line # End key
bindkey -M viins '^[[1;5C' forward-word # Ctrl-Right
bindkey -M viins '^[[1;5D' backward-word # Ctrl-Left
bindkey -M viins ${terminfo[kdch1]} delete-char # Del key
# Use beam in insert mode and block in normal
function zle-keymap-select {
  VI_KEYMAP=$KEYMAP
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
  zle reset-prompt
  zle -R
}
zle -N zle-keymap-select
_fix_cursor() {
   echo -ne '\e[5 q'
}
precmd_functions+=(_fix_cursor)

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
alias vim='nvim'
alias vims='nvim --servername VIM'
alias vimr='nvim --servername VIM --remote'
alias kubelogin='kubelogin --username $(lpass show 7660927770583698316 --username) --password $(lpass show 7660927770583698316 --password)'
function source-env() {
    source $HOME/development/env/$1.sh
}
function kxi(){
	local pod=$(kubectl get pods | fzf | awk '{print $1}')
	local containers=$(kubectl get pods "${pod}" -o jsonpath='{.spec.containers[*].name}')
	local container=${containers}
	if [[ $containers =~ ' ' ]]; then
		container=$(echo "${containers}" | tr ' ' '\n' | fzf)
	fi
	echo "${pod}" - "${container}"
	kubectl exec -it "${pod}" -c "${container}" -- "${@}"
}
function kli() {
	local pod=$(kubectl get pods | fzf | awk '{print $1}')
	local containers=$(kubectl get pods "${pod}" -o jsonpath='{.spec.containers[*].name}')
	local container=${containers}
	if [[ $containers =~ ' ' ]]; then
		container=$(echo "${containers}" | tr ' ' '\n' | fzf)
	fi
	echo "${pod}" - "${container}"
	kubectl logs "${@}" "${pod}" -c "${container}"
}
function klfi() {
	kli -f --tail=10
}
function kdi() {
	local typ=${1:-"pods"}
	local item=$(kubectl get "${typ}" | fzf | awk '{print $1}')
	kubectl describe "${typ}" "${item}"
}
function kcni() {
	local ns=$(kubectl get namespace | fzf | awk '{print $1}')
	local current=$(kubectl config current-context)
	kubectl config set-context "${current}" --namespace="${ns}"
}
