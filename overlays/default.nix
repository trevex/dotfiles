{ inputs, ... }:
self: super: {
  vimPlugins = super.vimPlugins // {
    nvim-cokeline = super.callPackage ../packages/nvim-cokeline { inherit inputs; };
  };
  gnomeExtensions = super.gnomeExtensions // {
    dynamic-panel-transparency = super.callPackage ../packages/dynamic-panel-transparency { };
  };
  apple-fonts = super.callPackage ../packages/apple-fonts { };
}
