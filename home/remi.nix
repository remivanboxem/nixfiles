{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./helix.nix
    ./zathura.nix
    ./beets.nix
    ./desktop.nix
    ./packages.nix
    ./sway.nix
    ./kathara.nix
  ];

  home.username = "remi";
  home.homeDirectory = "/home/remi";
  home.stateVersion = "24.11"; # I should upgrade to 26.05

  programs.home-manager.enable = true;

  # ── Sync ──────────────────────────────────────────────────────────────
  services.syncthing.enable = true; # port 8384
}
