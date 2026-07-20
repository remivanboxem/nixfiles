{
  config,
  pkgs,
  lib,
  ...
}:

{
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
    just

    # Editors
    zed-editor

    # Browsers
    brave
    firefox

    # Communication
    slack
    discord
    signal-desktop
    thunderbird
    teams-for-linux

    # Productivity
    libreoffice-fresh
    obsidian
    exiftool
    inkscape
    zotero

    # File manager
    yazi

    # Viewers & media
    imv
    mpv
    whipper
    picard
    beets

    # Screen recording
    obs-studio

    # Terminal multiplexer
    zellij

    # Auth / secrets
    networkmanagerapplet
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
    duckdb

    # C toolchain
    gcc
    pkg-config
    gcc-unwrapped

    # Containers
    # podman-compose
    docker

    # network tools
    wireshark

    # Language servers for Helix (auto-detected when in PATH)
    ruff # Python linter + formatter + LSP
    basedpyright # Python type checking + completions
    texlab # LaTeX LSP
    nixd # Nix LSP
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
    typst

    # MTP
    jmtpfs

    # Others
    awscli2
  ];
}
