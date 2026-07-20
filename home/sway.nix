{
  config,
  pkgs,
  lib,
  ...
}:

let
  modifier = "Mod4"; # Super
  screenshotDir = "${config.home.homeDirectory}/media/screenshots";
in
{
  # ── Sway ──────────────────────────────────────────────────────────────
  wayland.windowManager.sway = {
    enable = true;
    config = {
      inherit modifier;
      terminal = "foot";
      menu = "fuzzel";

      # Built-in swaybar. Its status line is plain-text i3status (no Nerd
      # Font glyphs), and swaybar carries its own tray for nm-applet.
      # Colours come from Stylix.
      bars = [
        {
          statusCommand = "${pkgs.i3status}/bin/i3status";
          position = "top";
        }
      ];

      gaps.inner = 8;

      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "intl";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled"; # disable-while-typing
        };
      };

      keybindings = lib.mkOptionDefault {
        "${modifier}+Return" = "exec foot";
        "${modifier}+d" = "exec fuzzel";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+Shift+v" =
          "exec cliphist list | fuzzel --dmenu | cliphist decode | wl-copy";
        "${modifier}+Ctrl+l" = "exec swaylock";

        # Media, volume & brightness
        "XF86AudioRaiseVolume" =
          "exec wpctl set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" =
          "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";

        # Screenshots (region / full screen) → clipboard + file
        "Print" =
          "exec grim -g \"$(slurp)\" - | tee \"${screenshotDir}/$(date +%Y-%m-%d_%H-%M-%S).png\" | wl-copy";
        "${modifier}+Print" =
          "exec grim - | tee \"${screenshotDir}/$(date +%Y-%m-%d_%H-%M-%S).png\" | wl-copy";
      };

      startup = [
        { command = "wl-paste --watch cliphist store"; }
        { command = "nm-applet --indicator"; }
        {
          command =
            "${pkgs.polkit_gnome}/libexec/polkit-gnome/polkit-gnome-authentication-agent-1";
        }
      ];
    };
  };

  # ── Status bar ────────────────────────────────────────────────────────
  # swaybar's status line. i3status ships a sane default (disk, load,
  # memory, network, battery, clock); drop a ~/.config/i3status/config or
  # set programs.i3status.modules here to customise.
  programs.i3status.enable = true;

  # ── Launcher ──────────────────────────────────────────────────────────
  programs.fuzzel.enable = true;

  # ── Screen lock & idle ────────────────────────────────────────────────
  programs.swaylock.enable = true;

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 600;
        command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
  };

  # ── Notifications ─────────────────────────────────────────────────────
  services.mako.enable = true;

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
    cliphist
    grim
    slurp
    brightnessctl
    playerctl
    polkit_gnome
  ];
}
