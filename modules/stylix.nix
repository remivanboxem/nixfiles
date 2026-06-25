{ pkgs, ... }:
{
  stylix = {
    enable = true;
    # Gallery link: https://tinted-theming.github.io/tinted-gallery/
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light.yaml";
    # image = pkgs.runCommand "bg.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    #   magick -size 1x1 xc:#fbf1c7 PNG:$out
    # '';
    polarity = "light";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Sans";
      };
      serif = {
        package = pkgs.ibm-plex;
        name = "IBM Serif";
      };
      sizes = {
        terminal = 11;
        applications = 11;
        desktop = 11;
      };
    };

    cursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
  };
}
