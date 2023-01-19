# Random assembly of notes

## NixOS

```
sudo nixos-rebuild switch --flake ".#$(hostname -s)"
```

```
sudo nix-collect-garbage -d
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system 
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
```


## Non-NixOS

```
# Install any version of nix
apt install nix
# Add user to `nix-users` group (and logout/login)
sudo usermod -a -G nix-users $USER
# Add the proper nixpkgs channel
nix-channel --add https://nixos.org/channels/nixos-22.11 nixpkgs
nix-channel --update
nix-instantiate '<nixpkgs>' -A hello # just to test
nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz home-manager
nix-channel --update
# Let's create the first generation with home-manager
nix-shell '<home-manager>' -A install
# Support for flakes
nix-env -iA nixpkgs.nixUnstable
```
Add to `.profile`:
```
export XDG_DATA_DIRS="$HOME/.nix-profile/share/:$XDG_DATA_DIRS"
```


Also source home-manager if `.bashrc` is off limits for `nix`:
```
. "/home/nvoss/.nix-profile/etc/profile.d/hm-session-vars.sh"
```

For alacritty you'll have to create a Desktop item manually as the packet is overriden, checkout its repository for an example and make sure to add required environment variables.

If nix command or flakes are not available:
```
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Some manual gnome stuff for now:
```
for i in {1..9}; do 
  gsettings set "org.gnome.shell.keybindings" "switch-to-application-$i" "[]"
  gsettings set "org.gnome.desktop.wm.keybindings" "switch-to-workspace-$i" "['<Super>${i}']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-${i} "['<Super><Shift>${i}']"
done
```

Also setup alacritty, e.g. copy command from desktop entry and create custom shortcut through GUI.

Obsolete once gnome settings are moved out of nixos module and part of home manager module.

## ZSH

Changing to zsh without `chsh` (change `.bashrc`):
```
if echo $- | grep -q 'i' && [[ -x "$HOME/.nix-profile/bin/zsh" ]]; then
  exec "$HOME/.nix-profile/bin/zsh" -i
fi
```

You might have to restart it after first run as plugins might install.


## Yubikey

To setup the Yubikey for use with `git` and `ssh`, we only really need to import and trust it. The Yubikey is expected to be fully setup via [drduh's guide](https://github.com/drduh/YubiKey-Guide).
```
# find you key id and import
gpg --keyserver keyserver.ubuntu.com --receive-keys 95a482bc50edbaa80df55b6382de9de03b66b361
# list your local keys
gpg -k
# edit and `trust` the key
gpg --edit-key 95A482BC50EDBAA80DF55B6382DE9DE03B66B361
# let's also store the public key for other uses
ssh-add -L | grep "cardno:000613075305" > ~/.ssh/id_rsa.pub
```

## Working with PDFs

## Gnome

`dconf dump /org/gnome/`

### Removing password

```
qpdf --password=<password> --decrypt input.pdf output.pdf
```

### Extract range of pages

```
pdftk input.pdf cat 2-3 output output.pdf
```

### Compressing PDFs

```
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=output.pdf input.pdf
```

Summary of -dPDFSETTINGS:

* `-dPDFSETTINGS=/screen` lower quality, smaller size. (72 dpi)
* `-dPDFSETTINGS=/ebook` for better quality, but slightly larger pdfs. (150 dpi)
* `-dPDFSETTINGS=/prepress` output similar to Acrobat Distiller "Prepress Optimized" setting (300 dpi)
* `-dPDFSETTINGS=/printer` selects output similar to the Acrobat Distiller "Print Optimized" setting (300 dpi)
* `-dPDFSETTINGS=/default` selects output intended to be useful across a wide variety of uses, possibly at the expense of a larger output file

Reference: https://www.ghostscript.com/doc/current/VectorDevices.htm#PSPDF_IN:


## Misc

### German Umlaute without Xmodmap

https://blog.florianheinle.de/englische-tastatur-umlaute

