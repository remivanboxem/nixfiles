{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [ inputs.kathara.homeManagerModules.default ];

  programs.kathara = {
    enable = true;
    manager = "docker";
    image = "kathara/base";
    terminal = "/usr/bin/foot";
    openTerminals = true;
    deviceShell = "/bin/bash";
    netPrefix = "kathara";
    devicePrefix = "kathara";
    debugLevel = "INFO";
    printStartupLog = true;
    enableIpv6 = false;

    # Optional: additional raw keys written to kathara.conf
    settings = { };
  };
}
