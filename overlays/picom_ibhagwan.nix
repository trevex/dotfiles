final: super: {
  picom = super.picom.overrideAttrs(_: {
    src = super.fetchFromGitHub {
      owner = "ibhagwan";
      repo = "picom";
      rev = "60eb00ce1b52aee46d343481d0530d5013ab850b";
      sha256 = "sha256-PDQnWB6Gkc/FHNq0L9VX2VBcZAE++jB8NkoLQqH9J9Q=";
    };
  });
}
