#!/bin/env bash

# Install necessary packages

required_packages=(firefox stow curl git pavucontrol pulseaudio-ctl manjaro-pulse rxvt-unicode polybar libmpdclient libxcb xcb-util-cursor xcb-util-image xcb-util-renderutil jsoncpp ttf-material-icons ttf-font-awesome ttf-dejavu paper-icon-theme lxappearance gtk-engine-murrine)

for p in "${required_packages[@]}"
do
  if pacman -Qi $p > /dev/null ; then
  	echo "Package ${p} already installed."
  else
    echo "Installing ${p}... (Might ask for sudo)"
    sudo pacman -Sy $p
  fi
done


# GNU/Stow

echo "Using stow to setup system configuration.."

stow fonts

# rm -rf $HOME/.config/gtk-2.0
# rm -rf $HOME/.config/gtk-3.0
stow gtk-theme

stow polybar

# rm $HOME/.config/dunst/dunstrc
stow dunst

# rm -rf $HOME/.config/rofi
stow rofi

# rm -rf $HOME/.config/bspwm
stow bspwm

# rm $HOME/.config/sxhkd/sxhkdrc
stow sxhkd

# rm $HOME/.profile
stow profile

# rm $HOME/.Xresources
stow x11


# Setup firefox

echo "Installing Firefox userChrome.css... (make sure firefox ran once before)"

profiles_file=$HOME/.mozilla/firefox/profiles.ini
if [[ $(grep '\[Profile[^0]\]' $profiles_file) ]]
  then PROFILE_PATH=$(grep -E '^\[Profile|^Path|^Default' $profiles_file | grep -1 '^Default=1' | grep '^Path' | cut -c6-)
  else PROFILE_PATH=$(grep 'Path=' $profiles_file | sed 's/^Path=//')
fi
mkdir -p $HOME/.mozilla/firefox/$PROFILE_PATH/chrome
cp firefox/userChrome.css $HOME/.mozilla/firefox/$PROFILE_PATH/chrome/userChrome.css


# Install oh my zsh

if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Skipping oh-my-zsh setup, because directory exists."
else
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  rm $HOME/.zshrc
  stow zsh
fi

