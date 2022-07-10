{ lib, stdenv, fetchFromGitHub, jq, ... }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-dynamic-panel-transparency";
  version = "unstable-2021-11-11";

  nativeBuildInputs = [
    jq
  ];

  src = fetchFromGitHub {
    owner = "ewlsh";
    repo = "dynamic-panel-transparency";
    rev = "63c8b81d5544cc1e6d2ee9fd236b705a531b641b";
    sha256 = "sha256-Kp1NDf/GyAKny06Fd/L0k60v8y1dXy1MKHg9Ngg0y/4=";
  };

  dontBuild = true;

  passthru = {
    extensionUuid = "dynamic-panel-transparency@rockon999.github.io";
    extensionPortalSlug = "dynamic-panel-transparency";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions

    # Add support for gnome shell 42
    cat <<< $(jq '.["shell-version"] += ["42"]' "dynamic-panel-transparency@rockon999.github.io/metadata.json" ) > "dynamic-panel-transparency@rockon999.github.io/metadata.json"

    cp -r "dynamic-panel-transparency@rockon999.github.io" $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description = "GNOME Shell extension adding transparency to gnome shell panel";
    license = licenses.gpl2;
    homepage = "https://github.com/ewlsh/dynamic-panel-transparency";
  };
}
