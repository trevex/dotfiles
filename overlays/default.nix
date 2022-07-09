{ inputs, ... }:
self: super: {
  vimPlugins = super.vimPlugins // {
    nvim-cokeline = super.callPackage ../packages/nvim-cokeline { inherit inputs; };
  };
}
