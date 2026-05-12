{
  config,
  pkgs,
  lib,
  ...
}:

let
  mod = "Mod4";
  laptop = "eDP-1";
in
{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = mod;
      terminal = "foot";
      menu = "fuzzel";
      bars = [ ];

      bindswitches = {
        "lid:on" = {
          reload = true;
          locked = true;
          action = "output ${laptop} disable";
        };
        "lid:off" = {
          reload = true;
          locked = true;
          action = "output ${laptop} enable";
        };
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "fr";
          # xkb_options = "caps:escape";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled";
        };
      };

      output = {
        "DP-3" = {
          mode = "2560x1440@100Hz";
          scale = "1";
          pos = "2560 0";
        }; # USB-C primary (2K 100 Hz)
        "DP-5" = {
          mode = "3840x2160@60Hz";
          scale = "1.5";
          pos = "0 0";
        }; # daisy-chained (4K 60 Hz, logical 1920×1080)
        "*".bg = "#282828 solid_color";
      };

      keybindings = lib.mkOptionDefault (
        {
          "${mod}+Return" = "exec foot";
          "${mod}+d" = "exec fuzzel";
          "${mod}+c" = "exec cliphist list | fuzzel --dmenu | cliphist decode | wl-copy";
          "${mod}+q" = "kill";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
          "${mod}+b" = "splith";
          "${mod}+v" = "splitv";
          "${mod}+e" = "layout toggle split";
          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+e" = "exec swaymsg exit";
          "${mod}+ctrl+l" = "exec swaylock -f -c 282828";

          "${mod}+Print" = "exec grim ~/media/screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png";
          "${mod}+Shift+Print" =
            "exec grim -g \"$(slurp)\" ~/media/screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png";

          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";
        }
        // {
          # AZERTY workspace bindings (unshifted keys on the number row)
          "${mod}+ampersand" = "workspace number 1";
          "${mod}+eacute" = "workspace number 2";
          "${mod}+quotedbl" = "workspace number 3";
          "${mod}+apostrophe" = "workspace number 4";
          "${mod}+parenleft" = "workspace number 5";
          "${mod}+minus" = "workspace number 6";
          "${mod}+egrave" = "workspace number 7";
          "${mod}+underscore" = "workspace number 8";
          "${mod}+ccedilla" = "workspace number 9";
          "${mod}+Shift+ampersand" = "move container to workspace number 1";
          "${mod}+Shift+eacute" = "move container to workspace number 2";
          "${mod}+Shift+quotedbl" = "move container to workspace number 3";
          "${mod}+Shift+apostrophe" = "move container to workspace number 4";
          "${mod}+Shift+parenleft" = "move container to workspace number 5";
          "${mod}+Shift+minus" = "move container to workspace number 6";
          "${mod}+Shift+egrave" = "move container to workspace number 7";
          "${mod}+Shift+underscore" = "move container to workspace number 8";
          "${mod}+Shift+ccedilla" = "move container to workspace number 9";
        }
      );

      startup = [
        { command = "waybar"; }
        { command = "mako"; }
        {
          command = "wl-paste --watch cliphist store";
          always = true;
        }
        { command = "nm-applet --indicator"; }
        { command = "blueman-applet"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        {
          command = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh";
        }
        {
          command = ''
            swayidle -w \
                        timeout 300 'swaymsg "output * dpms off"' \
                        resume 'swaymsg "output * dpms on"' \
                        before-sleep 'swaylock -f -c 282828' '';
        }
      ];
    };
  };

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "pulseaudio"
          "network"
          "battery"
          "clock"
          "tray"
        ];

        "sway/workspaces".disable-scroll = true;

        "clock" = {
          format = " {:%H:%M}";
          format-alt = " {:%Y-%m-%d %H:%M:%S}";
        };

        "battery" = {
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          states = {
            warning = 30;
            critical = 15;
          };
        };

        "network" = {
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ipaddr}";
          format-disconnected = "Disconnected";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          on-click = "pavucontrol";
        };

        "tray".spacing = 10;
      }
    ];

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }
      window#waybar {
        background-color: rgba(40, 40, 40, 0.95);
        color: #ebdbb2;
      }
      #workspaces button {
        padding: 0 5px;
        color: #a89984;
      }
      #workspaces button.focused {
        background-color: #3c3836;
        color: #ebdbb2;
      }
      #workspaces button:hover {
        background-color: #504945;
      }
      #clock, #battery, #network, #pulseaudio, #tray {
        padding: 0 10px;
        color: #ebdbb2;
      }
      #battery.warning { color: #fabd2f; }
      #battery.critical { color: #fb4934; }
    '';
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=11";
        dpi-aware = "auto";
        width = 35;
        lines = 10;
        terminal = "foot";
      };
      colors = {
        background = "282828ff";
        text = "ebdbb2ff";
        match = "fabd2fff";
        selection = "3c3836ff";
        selection-text = "ebdbb2ff";
        selection-match = "fabd2fff";
        border = "fabd2fff";
      };
      border = {
        radius = 4;
        width = 2;
      };
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=11";
        dpi-aware = "on";
      };
      mouse.hide-when-typing = "yes";
      colors-dark = {
        background = "282828";
        foreground = "ebdbb2";
        regular0 = "282828";
        regular1 = "cc241d";
        regular2 = "98971a";
        regular3 = "d79921";
        regular4 = "458588";
        regular5 = "b16286";
        regular6 = "689d6a";
        regular7 = "a89984";
        bright0 = "928374";
        bright1 = "fb4934";
        bright2 = "b8bb26";
        bright3 = "fabd2f";
        bright4 = "83a598";
        bright5 = "d3869b";
        bright6 = "8ec07c";
        bright7 = "ebdbb2";
      };
    };
  };

  services.mako = {
    enable = true;
    settings = {
      background-color = "#282828";
      text-color = "#ebdbb2";
      border-color = "#fabd2f";
      border-radius = 4;
      default-timeout = 5000;
    };
  };

  home.packages = with pkgs; [
    swaylock
    swayidle
    grim
    slurp
    wl-clipboard
    mako
    brightnessctl
    playerctl
    pavucontrol
    wdisplays
  ];
}
