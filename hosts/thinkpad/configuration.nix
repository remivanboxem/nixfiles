{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/laptop.nix
    ../../modules/sway.nix
    ../../modules/virtualisation.nix
  ];

  networking.hostName = "thinkpad";

  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable32Bit   = true;
    extraPackages = with pkgs; [
      amdvlk                # AMD Vulkan driver
      rocmPackages.clr.icd  # OpenCL / compute (optional, for GPU workloads)
    ];
  };

  services.fwupd.enable = true;

  system.stateVersion = "24.11";
}
