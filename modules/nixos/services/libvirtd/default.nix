{ options, config, lib, pkgs, mylib, ... }:

with lib;
with mylib;
let
  cfg = config.my.services.libvirtd;
in
{
  options.my.services.libvirtd = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    my.user.extraGroups = [ "libvirtd" ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [(pkgs.unstable.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd];
          };
        };
      };
    };

    programs.virt-manager.enable = config.my.desktop.gnome.enable;
  };
}
