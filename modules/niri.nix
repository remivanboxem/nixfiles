{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.niri.enable = true;

  # ── Login ─────────────────────────────────────────────────────────────
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "remi";
      };
    };
  };

  # ── Audio ─────────────────────────────────────────────────────────────
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.pulseaudio.enable = false;

  # ── Session ───────────────────────────────────────────────────────────
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
  };

  # ── Noctalia binary cache ─────────────────────────────────────────────
  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  # ── Fonts ─────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    nerd-fonts.jetbrains-mono
    corefonts # Microsoft font pack
    adwaita-fonts
    iosevka
    montserrat # UCLouvain font
    eb-garamond # UCLouvain font
  ];
}
