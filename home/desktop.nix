{
  config,
  pkgs,
  lib,
  ...
}:

{
  # ── Theming ───────────────────────────────────────────────────────────
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Light";
    };
  };

  # qt = {
  #   enable = true;
  #   platformTheme.name = "gtk";
  # };

  # ── Directories & defaults ────────────────────────────────────────────
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true; # keep legacy default (changes to false at stateVersion 26.05)
    documents = "$HOME/docs";
    pictures = "$HOME/media/pictures";
    videos = "$HOME/media/videos";
    music = "$HOME/media/music";
    download = "$HOME/dl";
    projects = "$HOME/dev";
    # suppress unwanted standard directories
    desktop = "$HOME";
    templates = "$HOME";
    publicShare = "$HOME";
  };

  home.activation.createExtraDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/notes $HOME/media/screenshots
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/pdf" = "evince.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/mkv" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "x-scheme-handler/mailto" = "thunderbird.desktop";
    };
  };
}
