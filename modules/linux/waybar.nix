{
  pkgs,
  config,
  ...
}:
let
  toJSON = (pkgs.formats.json { }).generate;

in
{
  home-manager.users.${config.username}.programs.waybar = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      mainBar = {
        # positioning and appearance
        layer = "top";
        position = "top";
        spacing = 4;
        margin-top = 5;
        margin-bottom = 0;
        margin-left = 5;
        margin-right = 5;

        # sections
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "tray"
          "pulseaudio"
          "backlight"
          "disk"
          "cpu"
          "memory"
          "battery"
          "clock"
        ];

        # module configurations
        "hyprland/workspaces" = {
          all-outputs = false;
          persistent-workspaces = {
            "HDMI-A-1" = [
              1
              2
              3
              4
              5
            ];
            "eDP-1" = [
              6
              7
              8
              9
              10
            ];
          };
        };
        "hyprland/window" = {
          max-length = 75;
        };
        "tray" = {
          icon-size = 12;
          spacing = 10;
        };
        pulseaudio = {
          format = "{icon} <b>{volume}</b>";
          format-bluetooth = "{icon}  {volume}%";
          format-bluetooth-muted = "󰝟 ";
          format-muted = " 󰝟 ";
          format-icons = {
            headphone = "";
            default = [
              "󰝟"
              ""
            ];
          };
          tooltip = false;
          on-click = "pavucontrol";
        };
        backlight = {
          device = "intel_backlight";
          format = "{percent}% {icon}";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
          ];
          on-scroll-down = "brightnessctl set 5%-";
          on-scroll-up = "brightnessctl set 5%+";
          rotate = 0;
        };
        disk = {
          format = "{free} 󰋊";
        };
        cpu = {
          format = "{usage}% ";
        };
        memory = {
          format = "{percentage}%  ";
        };
        battery = {
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂄";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format-plugged = "{capacity}% 󰚥";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%b %d %Y %H:%M}";
        };
      };
    };
    style = # css
      ''
        /* global styling */
        * {
          border: none;
          font-family: JetBrains Mono;
          font-size: 12px;
          background-color: transparent;
        }

        /* tooltips */
        tooltip {
          background-color: @base;
        }

        tooltip * {
          color: @text;
        }

        /* sway and hyprland workspaces */
        #workspaces {
          background-color: @base;
          color: @text;
          padding-left: 0.7em;
          padding-right: 0.7em;
        }

        #workspaces button {
          color: @text;
          padding: 0.4em 1.0em;
          border-radius: 0;
          border-bottom: 0.3em solid transparent;
        }

        #workspaces button.focused,
        #workspaces button.active {
          border-bottom-color: @lavender;
        }

        /* sway and hyprland window */
        window#waybar:not(.empty) #window,
        window#waybar.solo #window,
        window#waybar.floating #window,
        window#waybar.tiled #window,
        window#waybar.stacked #window,
        window#waybar.swallowing #window,
        window#waybar.tabbed #window {
          background-color: @base;
          color: @text;
          font-weight: bold;
          padding-left: 0.7em;
          padding-right: 0.7em;
        }

        /* right module container */
        .modules-right {
          background-color: @base;
          color: @text;
          font-weight: bold;
          padding-right: 0.7em;
        }

        #tray,
        #pulseaudio,
        #backlight,
        #disk,
        #cpu,
        #memory,
        #battery,
        #clock {
          padding: 0.2em 0.5em 0 0.5em;
        }

        /* tray */
        #tray {
          background-color: @lavender;
          padding-left: 1em;
          padding-right: 1em;
        }

        #tray window {
          background-color: @lavender;
        }

        /* pulseaudio */
        #pulseaudio {
          color: @mauve;
        }

        /* backlight */
        #backlight {
          color: @text;
        }

        /* disk */
        #disk {
          color: @sky;
        }

        /* cpu */
        #cpu {
          color: @yellow;
        }

        /* memory */
        #memory {
          color: @flamingo;
        }

        /* battery */
        #battery {
          color: @text;
        }

        #battery.warning {
          color: @peach;
        }

        #battery.critical {
          color: @red;
        }

        /* clock */
        #clock {
          color: @lavender;
        }
      '';
  };
}
