{ config, options, lib, ... }:

with lib;
with lib.my;
{
  options.my.nixGL = with types; {
    enable = mkBoolOpt false;
  };
}

