{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -lah";
      la = "eza -A";
      ".." = "cd ..";
      "..." = "cd ../..";
      nixr = "sudo nixos-rebuild switch --flake ~/.config/nixfiles#(hostname)";
      nixu = "nix flake update ~/.config/nixfiles";
      g = "git";
      gs = "git status";
      gd = "git diff";
      # docker = "podman";
      open = "xdg-open";
    };
  };

  programs.starship.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
}
