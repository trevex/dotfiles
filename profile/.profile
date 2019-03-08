# $HOME/.profile

# set our umask
umask 022

# set our default path
export GOPATH="$HOME/Development/go"
# /usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
export PATH="$PATH:$HOME/.bin:$GOPATH/bin"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_DIRS=/usr/etc/xdg:/etc/xdg
export GUI_EDITOR=/usr/bin/gvim
export BROWSER=/usr/bin/firefox
export TERMINAL=/usr/bin/urxvt
export QT_QPA_PLATFORMTHEME="qt5ct"
export VISUAL=/usr/bin/vim
export EDITOR=/usr/bin/vim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix for java apps like IntelliJ
export _JAVA_AWT_WM_NONREPARENTING=1

# load profiles from /etc/profile.d
if test -d /etc/profile.d/; then
	for profile in /etc/profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi

# source global bash config
if test "$PS1" && test "$BASH" && test -r /etc/bash.bashrc; then
	. /etc/bash.bashrc
fi

# termcap is outdated, old, and crusty, kill it.
unset TERMCAP

# man is much better than us at figuring this out
unset MANPATH
