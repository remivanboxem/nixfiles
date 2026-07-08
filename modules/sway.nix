{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      xwayland
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # services.greetd = {
  #   enable = true;
  #   settings.default_session = {
  #     command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
  #     user = "greeter";
  #   };
  # };

  services.displayManager.gdm = {
    enable = true;
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.pulseaudio.enable = false;
  hardware.graphics.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
  };

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
