{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    keep-derivations = true;
    keep-outputs = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  time.timeZone = "Europe/Brussels";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  users.users.remi = {
    isNormalUser = true;
    description = "Rémi Van Boxem";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "input"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    htop
    nixd
  ];

  hardware.enableRedistributableFirmware = true;

  nixpkgs.config.allowUnfree = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      samba            # SMB/CIFS backend for smb:// URIs
      foomatic-db-ppds # PPD database (includes Ricoh IM C5510)
      foomatic-db-engine
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.pcscd.enable = true;

  programs.nix-ld.enable = true;

  services.flatpak.enable = true;

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  networking.firewall.enable = true;

  security.pam.services.greetd.enableGnomeKeyring = true;
}
