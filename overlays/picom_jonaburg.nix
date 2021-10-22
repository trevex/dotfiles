final: super: {
  picom = super.picom.overrideAttrs(_: {
    src = super.fetchFromGitHub {
      owner = "jonaburg";
      repo = "picom";
      rev = "a8445684fe18946604848efb73ace9457b29bf80";
      sha256 = "sha256-R+YUGBrLst6CpUgG9VCwaZ+LiBSDWTp0TLt1Ou4xmpQ=";
    };
  });
}
