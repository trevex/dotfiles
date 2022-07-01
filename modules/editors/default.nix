{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.my.editors;
in
{
  options.my.editors = {
    default = mkOpt types.str "vim";
  };

  config = mkIf (cfg.default != null) {
    my.env.EDITOR = cfg.default;
  };
}
