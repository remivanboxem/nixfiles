{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [ inputs.noctalia.homeModules.default ];

  # ── Noctalia ──────────────────────────────────────────────────────────
  # https://docs.noctalia.dev/v5.
  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "light";
        source = "builtin";
        builtin = "Ayu";
      };
    };
  };

  # ── Niri ──────────────────────────────────────────────────────────────
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "us"
                variant "intl"
            }
        }
        touchpad {
            tap
            natural-scroll
            dwt
        }
    }

    prefer-no-csd

    hotkey-overlay {
        skip-at-startup
    }

    layout {
        gaps 8
        center-focused-column "never"
        default-column-width { proportion 0.5; }
    }

    // ── Startup ──
    spawn-at-startup "noctalia"

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }

        // Apps & Noctalia panels
        Mod+Return hotkey-overlay-title="Terminal" { spawn "foot"; }
        Mod+D hotkey-overlay-title="App launcher" { spawn-sh "noctalia msg panel-toggle launcher"; }
        Mod+Space hotkey-overlay-title="App launcher" { spawn-sh "noctalia msg panel-toggle launcher"; }
        Mod+V hotkey-overlay-title="Clipboard history" { spawn-sh "noctalia msg panel-toggle clipboard"; }
        Mod+S hotkey-overlay-title="Control center" { spawn-sh "noctalia msg panel-toggle control-center"; }
        Mod+W hotkey-overlay-title="Wallpaper picker" { spawn-sh "noctalia msg panel-toggle wallpaper"; }
        Mod+Shift+E hotkey-overlay-title="Session menu" { spawn-sh "noctalia msg panel-toggle session"; }
        Mod+Ctrl+L hotkey-overlay-title="Lock" { spawn-sh "noctalia msg session lock"; }

        // Window management
        Mod+Q { close-window; }
        Mod+F { fullscreen-window; }
        Mod+Shift+F { maximize-column; }
        Mod+C { center-column; }
        Mod+R { switch-preset-column-width; }
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Shift+Space { toggle-window-floating; }
        Mod+Comma { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }
        Mod+Shift+H { move-column-left; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+L { move-column-right; }
        Mod+Home { focus-column-first; }
        Mod+End { focus-column-last; }

        // Move a column between monitors
        Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+L { move-column-to-monitor-right; }

        // Workspaces (dynamic, vertical)
        Mod+U { focus-workspace-down; }
        Mod+I { focus-workspace-up; }
        Mod+Ctrl+U { move-column-to-workspace-down; }
        Mod+Ctrl+I { move-column-to-workspace-up; }
        Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Ctrl+1 { move-column-to-workspace 1; }
        Mod+Ctrl+2 { move-column-to-workspace 2; }
        Mod+Ctrl+3 { move-column-to-workspace 3; }
        Mod+Ctrl+4 { move-column-to-workspace 4; }
        Mod+Ctrl+5 { move-column-to-workspace 5; }
        Mod+Ctrl+6 { move-column-to-workspace 6; }
        Mod+Ctrl+7 { move-column-to-workspace 7; }
        Mod+Ctrl+8 { move-column-to-workspace 8; }
        Mod+Ctrl+9 { move-column-to-workspace 9; }

        // Media, volume & brightness
        XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "noctalia msg volume-up"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn-sh "noctalia msg volume-down"; }
        XF86AudioMute allow-when-locked=true { spawn-sh "noctalia msg volume-mute"; }
        XF86AudioMicMute allow-when-locked=true { spawn-sh "noctalia msg mic-mute"; }
        XF86MonBrightnessUp allow-when-locked=true { spawn-sh "noctalia msg brightness-up"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn-sh "noctalia msg brightness-down"; }
        XF86AudioPlay allow-when-locked=true { spawn-sh "noctalia msg media toggle"; }
        XF86AudioNext allow-when-locked=true { spawn-sh "noctalia msg media next"; }
        XF86AudioPrev allow-when-locked=true { spawn-sh "noctalia msg media previous"; }

        // Screenshots
        Print { spawn-sh "noctalia msg screenshot-region"; }
        Mod+Print { spawn-sh "noctalia msg screenshot-fullscreen"; }
        Mod+Shift+Print { spawn-sh "noctalia msg screenshot-fullscreen pick"; }
    }
  '';

  # ── Terminal ──────────────────────────────────────────────────────────
  programs.foot = {
    enable = true;
    settings = {
      main.dpi-aware = lib.mkForce "on";
      mouse.hide-when-typing = "yes";
    };
  };

  # ── Output profiles ───────────────────────────────────────────────────
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "Dell Inc. DELL P2715Q 32R1F53S331L";
            mode = "3840x2160@59.997Hz";
            transform = "90";
            scale = 1.5;
            position = "0,0";
          }
          {
            criteria = "Dell Inc. DELL P2725DE 5FR0RB4";
            mode = "2560x1440@99.946Hz";
            scale = 1.0;
            position = "2560,0";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      }
      {
        profile.name = "single";
        profile.outputs = [
          {
            criteria = "Dell Inc. DELL P2725DE 5FR0RB4";
            mode = "2560x1440@99.946Hz";
            scale = 1.0;
            position = "0,0";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      }
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.0;
            status = "enable";
          }
        ];
      }
    ];
  };

  # ── Wayland utilities ─────────────────────────────────────────────────
  home.packages = with pkgs; [
    wl-clipboard
  ];
}
