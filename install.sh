#!/bin/env bash

# Install necessary packages
required_packages=(firefox stow vim rxvt-unicode polybar rofi polybar playerctl feh compton ranger imagemagick i3lock ntp ttf-dejavu ttf-material-icons ttf-font-awesome dunst libnotify w3m autorandr gtk-engine-murrine gtk-engines numix lxappearance mupdf paper-icon-theme numix-gtk-theme pulseaudio pulseaudio-alsa pavucontrol xorg-xbacklight fzf ripgrep)

# nerd-fonts-dejavu-complete

for p in "${required_packages[@]}"
do
  if pacman -Qi $p > /dev/null ; then
  	echo "Package ${p} already installed."
  else
    echo "Installing ${p}... (might ask for sudo)"
    sudo pacman -Sy $p
  fi
done

required_packages_aur=(i3lock-color)

for p in "${required_packages_aur[@]}"
do
  if pacman -Qi $p > /dev/null ; then
    echo "Package ${p} (AUR) already installed."
  else
    echo "Installing ${p}... (via AUR)"
    yay -S $p
  fi
done


# Initialise git submodules
git submodule update --init


# GNU/Stow
echo "Using stow to setup system configuration.."
stow compton
stow i3lock
sudo cp systemd/i3lock@.service /etc/systemd/system/
sudo systemctl enable i3lock@$USER.service
stow gtk
stow polybar
stow dunst
stow rofi
stow bspwm
stow sxhkd
stow profile
stow xorg
stow wallpapers
stow vim
stow urxvt

# Install oh my zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Skipping oh-my-zsh setup, because directory exists."
  rm $HOME/.zshrc
  stow zsh
else
  echo "Installing oh-my-zsh... (Run install again to get proper .zshrc)"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  rm $HOME/.zshrc
  stow zsh
fi

sudo systemctl enable ntpd.service

