# Setup

## First things first

1. Install firefox
2. Install iterm2
3. Download and setup gruvbox theme for iterm2

## Let's get yabai going

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install koekeishiya/formulae/yabai
sudo yabai --install-sa
brew services start yabai && killall Dock
```

```
brew install stow
brew install jq
```

```
brew install koekeishiya/formulae/skhd
brew services start skhd
```

```
brew install zplug
stow zsh
source ~/.zshrc
zplug install
zplug load
# if zsh compinit: insecure directories, run compaudit for list.
$ sudo chmod -R 755 /usr/local/share/zsh
```

yubikey setup
```
brew install gnupg yubikey-personalization hopenpgp-tools ykman pinentry-mac
```

rng
```
brew install go make nodejs neovim
```
