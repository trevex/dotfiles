# Random assembly of notes

## NixOS

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

## Working with PDFs

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