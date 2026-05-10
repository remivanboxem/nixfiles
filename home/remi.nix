{ config, pkgs, lib, inputs, ... }:

{
  imports = [ ./sway.nix ];

  home.username      = "remi";
  home.homeDirectory = "/home/remi";
  home.stateVersion  = "24.11"; # I should upgrade to 26.05

  programs.home-manager.enable = true;

  # ── Sync ──────────────────────────────────────────────────────────────
  services.syncthing.enable = true;   # port 8384

  # For nightlight
  services.gammastep = {
    enable    = true;
    # Brussels
    latitude  = 50.85;
    longitude = 4.35;
    temperature = {
      day   = 6500;
      night = 3500;
    };
  };

  # ── Shell ─────────────────────────────────────────────────────────────
  programs.direnv = {
    enable            = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ll     = "eza -lah";
      la     = "eza -A";
      ".."   = "cd ..";
      "..."  = "cd ../..";
      nixr   = "sudo nixos-rebuild switch --flake ~/.config/nixfiles#(hostname)";
      nixu   = "nix flake update ~/.config/nixfiles";
      g      = "git";
      gs     = "git status";
      gd     = "git diff";
      docker = "podman";
    };
  };

  programs.starship.enable = true;

  programs.zoxide = {
    enable                = true;
    enableFishIntegration = true;
  };

  # ── Git ───────────────────────────────────────────────────────────────
  programs.git = {
    enable    = true;
    userName  = "Rémi Van Boxem";
    userEmail = "remi.vanboxem@uclouvain.be";

    extraConfig = {
      init.defaultBranch   = "main";
      pull.rebase          = true;
      push.autoSetupRemote = true;
      core.editor          = "hx";
    };

    delta = {
      enable  = true;
      options = { navigate = true; line-numbers = true; };
    };

    # Stolen from Bartho's config
    aliases = {
      cm = "commit -m";
      cma = "! git add . && git commit -m";
      a = "commit --amend";
      a-all = "! git add . && git commit --amend --no-edit";
      f-push = "! git add . && git commit --amend --no-edit && git push --force-with-lease";
      ch = "checkout";
      s = "status -sb";
      unstage = "reset HEAD --";
      uncommit = "reset --soft HEAD^";
      discard = "reset --hard HEAD";
      # graph = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
      g = "! git graph";
      graph = "! git-graph";
      count-lines = "! git log --author=\"$1\" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf \"added lines: %s, removed lines: %s, total lines: %s\\n\", add, subs, loc }' #";
    };

  };

  # ── Editors ───────────────────────────────────────────────────────────
  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox_dark_hard";
      editor = {
        line-number  = "relative";
        cursor-shape = { insert = "bar"; normal = "block"; select = "underline"; };
        indent-guides.render    = true;
        file-picker.hidden      = false;
        lsp.display-inlay-hints = true;
      };
    };
  };

  programs.zathura = {
    enable = true;
    options = {
      recolor             = true;
      recolor-lightcolor  = "#282828";
      recolor-darkcolor   = "#ebdbb2";
      default-bg          = "#282828";
      default-fg          = "#ebdbb2";
      statusbar-bg        = "#3c3836";
      statusbar-fg        = "#ebdbb2";
      inputbar-bg         = "#282828";
      inputbar-fg         = "#ebdbb2";
      selection-clipboard = "clipboard";
    };
  };

  # ── Browsers ──────────────────────────────────────────────────────────
  programs.firefox.enable = true;

  # ── Email ─────────────────────────────────────────────────────────────
  programs.thunderbird = {
    enable   = true;
    profiles = {};
  };

  # ── Packages ──────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    # CLI utilities
    ripgrep fd bat eza fzf jq unzip zip

    # Editors
    zed-editor

    # Browsers
    brave

    # Communication
    slack
    vesktop

    # Productivity
    bitwarden-desktop
    libreoffice-fresh

    # File manager
    yazi

    # Viewers & media
    zathura
    imv
    mpv

    # Screen recording
    obs-studio

    # Terminal multiplexer
    zellij

    # Clipboard history
    cliphist

    # System tray & auth
    networkmanagerapplet
    blueman
    polkit_gnome
    gnome-keyring

    # Rust
    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy

    # Python
    python3
    uv

    # C toolchain
    gcc
    pkg-config

    # Containers
    podman-compose

    # Language servers for Helix (auto-detected when in PATH)
    ruff          # Python linter + formatter + LSP
    basedpyright  # Python type checking + completions
    texlab        # LaTeX LSP
    nil           # Nix LSP

    # YubiKey
    yubikey-manager
    yubioath-flutter

    # VPN
    protonvpn-gui
    openvpn

    # Printing
    system-config-printer

    # LaTeX
    texlive.combined.scheme-full
  ];
}
