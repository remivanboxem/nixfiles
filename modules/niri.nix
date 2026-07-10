{
  config,
  pkgs,
  lib,
  ...
}:
{
programs.niri.enable = true;

services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = "${config.programs.niri.package}/bin/niri-session";
      user = "remi";
    };
  };
};
}
