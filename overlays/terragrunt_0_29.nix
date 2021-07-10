final: prev: {
  terragrunt_0_29 = prev.callPackage ({ lib, buildGoModule, fetchFromGitHub }: buildGoModule rec {
    pname = "terragrunt";
    version = "0.29.9";

    src = fetchFromGitHub {
      owner = "gruntwork-io";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-xgoKxA8lc72yhFVHeFkbF5j5/vGAd9TTaJ/aDEYL8Wg=";
    };

    vendorSha256 = "sha256-qlSCQtiGHmlk3DyETMoQbbSYhuUSZTsvAnBKuDJI8x8=";

    doCheck = false;

    preBuild = ''
      buildFlagsArray+=("-ldflags" "-s -w -X main.VERSION=v${version}")
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      $out/bin/terragrunt --help
      $out/bin/terragrunt --version | grep "v${version}"
      runHook postInstallCheck
    '';
  }) {};
}
