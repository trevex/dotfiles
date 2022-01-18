{ config, pkgs, lib, profiles, ... }:

{
  imports = with profiles; [ zsh ];
}
