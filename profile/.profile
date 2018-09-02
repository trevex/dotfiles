# $HOME/.profile

#Set our umask
umask 022

# Set our default path
export GOPATH="$HOME/Development/go"
PATH="/usr/local/sbin:/usr/local/bin:/usr/bin/core_perl:/usr/bin:$HOME/.config/bspwm/panel:$HOME/.bin:$GOPATH/bin"
export PANEL_FIFO="/tmp/panel-fifo"
export PATH
export XDG_CONFIG_HOME="$HOME/.config"
export BSPWM_SOCKET="/tmp/bspwm-socket"
export PANEL_HEIGHT=25
export XDG_CONFIG_DIRS=/usr/etc/xdg:/etc/xdg
export GUI_EDITOR=/usr/bin/micro-st
export BROWSER=/usr/bin/firefox
export TERMINAL=/usr/bin/urxvt
export QT_QPA_PLATFORMTHEME="qt5ct"
export VISUAL=/usr/bin/micro
export EDITOR=/usr/bin/micro
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# Fix for java apps like IntelliJ
export _JAVA_AWT_WM_NONREPARENTING=1

# Load profiles from /etc/profile.d
if test -d /etc/profile.d/; then
	for profile in /etc/profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi

# Source global bash config
if test "$PS1" && test "$BASH" && test -r /etc/bash.bashrc; then
	. /etc/bash.bashrc
fi

# Termcap is outdated, old, and crusty, kill it.
unset TERMCAP

# Man is much better than us at figuring this out
unset MANPATH
