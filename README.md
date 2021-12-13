# My `dotfiles`

```
sudo nixos-rebuild switch --flake ".#$(hostname -s)"
```

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
