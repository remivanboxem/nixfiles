{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/laptop.nix
    ../../modules/sway.nix
    ../../modules/virtualisation.nix
  ];

  networking.hostName = "se25-285";

  boot = {
    initrd = {
      systemd.enable = true;
      kernelModules = [ "i915" ];
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  services.fwupd.enable = true;

  # boot.kernelParams = lib.mkAfter [ "mem_sleep_default=s2idle" ];

  system.stateVersion = "24.11";
}
