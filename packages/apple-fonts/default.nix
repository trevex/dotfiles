{ pkgs, stdenv, fetchurl, lib, ... }:
stdenv.mkDerivation rec {
  pname = "apple-fonts";
  version = "1";

  pro = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
    sha256 = "sha256-loqzuLH5LC2K9h6waA9cIiTE541ZuYa/AEUCp/wBKRg=";
  };

  compact = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg";
    sha256 = "sha256-wdDjROut1m62LwP4I3hMzknxeH9WVj+wmPygH8VUE1w=";
  };

  mono = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
    sha256 = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
  };

  ny = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg";
    sha256 = "sha256-HC7ttFJswPMm+Lfql49aQzdWR2osjFYHJTdgjtuI+PQ=";
  };

  nativeBuildInputs = [ pkgs.p7zip pkgs.nerd-font-patcher ];

  sourceRoot = ".";

  dontUnpack = true;

  buildPhase = ''
    mkdir -p $out/fontfiles

    # Apple now ships two DMG layouts. SF Pro and SF Compact are APFS images
    # wrapping a flat package, which 7z unwraps all the way down to the cpio in
    # one step; SF Mono and NY are still HFS+ images nesting a
    # <Name>Fonts/<Name> Fonts.pkg. Handle both, and give each DMG its own work
    # dir since the new layout drops Payload~ straight into the cwd. The cpio
    # needs an explicit -tcpio: it is the 070707 (odc) variant and 7z fails to
    # sniff that out of the two large payloads.
    for dmg in ${pro} ${compact} ${mono} ${ny}; do
      work=$(mktemp -d)
      (
        cd $work
        7z x $dmg
        if [ ! -e 'Payload~' ]; then
          cd *Fonts
          7z x ./*.pkg
        fi
        7z x -tcpio 'Payload~'
        mv Library/Fonts/* $out/fontfiles/
      )
      rm -rf $work
    done

    for f in $out/fontfiles/SF-Mono-*; do
     nerd-font-patcher $f --mono --quiet --fontawesome --octicons --pomicons --codicons --powerline --out $out/fontfiles
    done
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/opentype $out/share/fonts/truetype
    mv $out/fontfiles/*.otf $out/share/fonts/opentype
    mv $out/fontfiles/*.ttf $out/share/fonts/truetype
    rm -rf $out/fontfiles
  '';

  meta = {
    description = "Apple San Francisco, New York fonts";
    homepage = "https://developer.apple.com/fonts/";
    license = lib.licenses.unfree;
  };
}
