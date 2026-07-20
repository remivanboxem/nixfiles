{
  config,
  pkgs,
  lib,
  ...
}:

{
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
}
