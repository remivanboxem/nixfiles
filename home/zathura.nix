{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.zathura = {
    enable = true;
    options = {
      recolor = true;
      selection-clipboard = "clipboard";
    };
  };
}
