{ config, pkgs, lib, ... }:

{
  # Podman
  virtualisation.podman = {
    enable       = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # QEMU/KVM/libvirt
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package       = pkgs.qemu_kvm;
      runAsRoot     = false;
      swtpm.enable  = true;
      ovmf.enable   = true;
    };
  };

  programs.virt-manager.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  users.users.remi.extraGroups = [ "libvirtd" "podman" ];
}
