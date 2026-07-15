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
  # Wayland shell: bar, notifications, launcher, control center, lock, etc.
  # Replaces the old waybar + mako stack. Settings can still be tweaked at
  # runtime from Noctalia's own settings menu; see https://docs.noctalia.dev/v5.
  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
    };
  };

  # ── Niri ──────────────────────────────────────────────────────────────
  # Config written as raw KDL (nixpkgs' niri module has no settings option).
  # Ported from the previous Sway keybindings, including the AZERTY number
  # row. Outputs are handled by kanshi below (niri speaks the
  # wlr-output-management protocol kanshi uses).
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "fr"
            }
        }
        touchpad {
            tap
            natural-scroll
            dwt
        }
    }

    prefer-no-csd

    screenshot-path "~/media/screenshots/screenshot-%Y%m%d-%H%M%S.png"

    layout {
        gaps 8
        center-focused-column "never"
        default-column-width { proportion 0.5; }
    }

    // ── Startup ──
    spawn-at-startup "noctalia"
    spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    spawn-at-startup "wl-paste" "--watch" "cliphist" "store"

    binds {
        // Apps
        Mod+Return { spawn "foot"; }
        Mod+D { spawn "fuzzel"; }
        Mod+C { spawn "sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"; }

        // Window management
        Mod+Q { close-window; }
        Mod+F { fullscreen-window; }
        Mod+R { switch-preset-column-width; }
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

        // Workspaces (AZERTY number row — unshifted keysyms)
        Mod+ampersand   { focus-workspace 1; }
        Mod+eacute      { focus-workspace 2; }
        Mod+quotedbl    { focus-workspace 3; }
        Mod+apostrophe  { focus-workspace 4; }
        Mod+parenleft   { focus-workspace 5; }
        Mod+minus       { focus-workspace 6; }
        Mod+egrave      { focus-workspace 7; }
        Mod+underscore  { focus-workspace 8; }
        Mod+ccedilla    { focus-workspace 9; }
        Mod+Shift+ampersand   { move-column-to-workspace 1; }
        Mod+Shift+eacute      { move-column-to-workspace 2; }
        Mod+Shift+quotedbl    { move-column-to-workspace 3; }
        Mod+Shift+apostrophe  { move-column-to-workspace 4; }
        Mod+Shift+parenleft   { move-column-to-workspace 5; }
        Mod+Shift+minus       { move-column-to-workspace 6; }
        Mod+Shift+egrave      { move-column-to-workspace 7; }
        Mod+Shift+underscore  { move-column-to-workspace 8; }
        Mod+Shift+ccedilla    { move-column-to-workspace 9; }

        // Session
        Mod+Shift+E { quit; }
        Mod+Ctrl+L { spawn "loginctl" "lock-session"; }

        // Screenshots (niri built-in)
        Print { screenshot; }
        Mod+Print { screenshot-screen; }
        Mod+Shift+Print { screenshot-window; }

        // Media & brightness
        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "set" "+5%"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "5%-"; }
        XF86AudioPlay allow-when-locked=true { spawn "playerctl" "play-pause"; }
        XF86AudioNext allow-when-locked=true { spawn "playerctl" "next"; }
        XF86AudioPrev allow-when-locked=true { spawn "playerctl" "previous"; }
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

  # ── Launcher ──────────────────────────────────────────────────────────
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        dpi-aware = "auto";
        width = 35;
        lines = 10;
        terminal = "foot";
      };
      border = {
        radius = 4;
        width = 2;
      };
    };
  };

  # ── Output profiles ───────────────────────────────────────────────────
  # kanshi drives docked/single/undocked auto-switching over niri's IPC.
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
            status = "enable";
          }
        ];
      }
    ];
  };

  # ── Wayland utilities ─────────────────────────────────────────────────
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    brightnessctl
    playerctl
    pavucontrol
  ];
}
