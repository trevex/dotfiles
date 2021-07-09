{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.29.10";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JRIwPOExPbwLS7ps4pJpvIRaZ9jZZjVK+POaUHAmiPI=";
  };

  vendorSha256 = "sha256-lck4nabDhFA8N0lo+cIKiJjlg2TGx3qMExbblHQwbvQ=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.VERSION=v${version}" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/terragrunt --help
    $out/bin/terragrunt --version | grep "v${version}"
    runHook postInstallCheck
  '';
}
