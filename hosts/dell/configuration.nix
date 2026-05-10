{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/laptop.nix
    ../../modules/sway.nix
    ../../modules/virtualisation.nix
  ];

  networking.hostName = "dell";

  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.kernelModules = [ "i915" ];

  hardware.graphics = {
    enable      = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  services.fwupd.enable = true;

  # boot.kernelParams = lib.mkAfter [ "mem_sleep_default=s2idle" ];

  system.stateVersion = "24.11";
}
