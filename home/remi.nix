{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [ ./sway.nix ];

  home.username = "remi";
  home.homeDirectory = "/home/remi";
  home.stateVersion = "24.11"; # I should upgrade to 26.05

  programs.home-manager.enable = true;

  # ── Sync ──────────────────────────────────────────────────────────────
  services.syncthing.enable = true; # port 8384

  # For nightlight
  services.gammastep = {
    enable = true;
    # Brussels
    latitude = 50.85;
    longitude = 4.35;
    temperature = {
      day = 6500;
      night = 3500;
    };
  };

  # ── Shell ─────────────────────────────────────────────────────────────
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
      docker = "podman";
      open = "xdg-open";
    };
  };

  programs.starship.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # ── Git ───────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    lfs.enable = true;

    # Git settings
    settings = {
      user.name = "Rémi Van Boxem";
      user.email = "remi.vanboxem@uclouvain.be";
      color.ui = "auto";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "hx";
      init.defaultBranch = "main";
    };

    # Git signing
    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/git-signing";
      signByDefault = true;
    };

    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
      };
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
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
        file-picker.hidden = false;
        lsp.display-inlay-hints = true;
      };
    };
  };

  programs.zathura = {
    enable = true;
    options = {
      recolor = true;
      selection-clipboard = "clipboard";
    };
  };

  # ── Theming ───────────────────────────────────────────────────────────
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Light";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  # ── Browsers ──────────────────────────────────────────────────────────
  programs.firefox.enable = true;

  # ── Email ─────────────────────────────────────────────────────────────
  programs.thunderbird = {
    enable = true;
    profiles = { };
  };

  # home/remi.nix
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  # ── Packages ──────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    # CLI utilities
    ripgrep
    fd
    bat
    eza
    fzf
    jq
    unzip
    zip
    comma

    # Editors
    zed-editor

    # Browsers
    brave

    # Communication
    slack
    discord

    # Productivity
    bitwarden-desktop
    libreoffice-fresh
    obsidian
    inkscape

    # File manager
    yazi

    # Viewers & media
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
    ruff # Python linter + formatter + LSP
    basedpyright # Python type checking + completions
    texlab # LaTeX LSP
    nil # Nix LSP

    # YubiKey
    yubikey-manager
    yubioath-flutter

    # VPN
    proton-vpn
    openvpn

    # Printing
    system-config-printer

    # LaTeX
    texlive.combined.scheme-full
  ];
}
