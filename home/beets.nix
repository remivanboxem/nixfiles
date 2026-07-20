{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.beets = {
    enable = true;
    settings = {
      directory = "~/media/music";
      library = "~/media/music/musiclibrary.db";
      original_date = true;
      per_disc_numbering = true;
      asciify_path = true;
      import = {
        copy = true;
      };
      plugins = [
        "musicbrainz"
        "deezer"
        "embedart"
        "lyrics"
        "fetchart"
      ];
      fetchart = {
        auto = true;
        cautious = false;
        minwidth = 1000;
        maxwidth = 3000;
        sources = [
          "filesystem"
          "coverart"
          "itunes"
          "albumart"
        ];
      };
      lyrics = {
        auto = false;
        sources = "*";
        synced = true;
      };
    };
  };
}
