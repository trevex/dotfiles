{ inputs, ... }:
self: super: {
  # Not required anymore as it is upstream, but leaving for documentation purposes:
  # vimPlugins = super.vimPlugins // {
  #   nvim-cokeline = super.callPackage ../packages/nvim-cokeline { inherit inputs; };
  # };
  gnomeExtensions = super.gnomeExtensions // {
    dynamic-panel-transparency = super.callPackage ../packages/dynamic-panel-transparency { };
  };
  apple-fonts = super.callPackage ../packages/apple-fonts { };
}
