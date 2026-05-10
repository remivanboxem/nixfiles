{ config, pkgs, lib, ... }:

{
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable      = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable        = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC    = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT   = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC  = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      START_CHARGE_THRESH_BAT0      = 75;
      STOP_CHARGE_THRESH_BAT0       = 80;
      WIFI_PWR_ON_AC                = "off";
      WIFI_PWR_ON_BAT               = "on";
    };
  };

  services.logind = {
    lidSwitch              = "suspend";
    lidSwitchExternalPower = "suspend";
    extraConfig = ''
      HandlePowerKey=suspend
      IdleAction=ignore
    '';
  };

  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "mem_sleep_default=deep"
  ];

  services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanager-openvpn
  ];
}
