{
  pkgs,
  config,
  ...
}:
let
  toJSON = (pkgs.formats.json { }).generate;

in
{
  home-manager.users.${config.username} =
    { config, ... }:
    let
      colors = config.lib.stylix.colors;
    in
    {
      # stylix interferes a little with how I want waybar to look, pulling in the stylix color scheme in the css manually
      stylix.targets.waybar.enable = false;

      programs.waybar = {
        enable = true;
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
              on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
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
              background-color: transparent;
              font-family: "${config.stylix.fonts.monospace.name}";
              font-size: ${builtins.toString config.stylix.fonts.sizes.desktop}pt;
            }

            /* tooltips */
            tooltip {
              background-color: ${colors.withHashtag.base00};
            }

            tooltip * {
              color: ${colors.withHashtag.base05};
            }

            /* sway and hyprland workspaces */
            #workspaces {
              background-color: ${colors.withHashtag.base00};
              color: ${colors.withHashtag.base05};
              padding-left: 0.7em;
              padding-right: 0.7em;
            }

            #workspaces button {
              color: ${colors.withHashtag.base05};
              padding: 0.4em 1.0em;
              border-radius: 0;
              border-bottom: 0.3em solid transparent;
            }

            #workspaces button.focused,
            #workspaces button.active {
              border-bottom-color: ${colors.withHashtag.base07};
            }

            /* sway and hyprland window */
            window#waybar:not(.empty) #window,
            window#waybar.solo #window,
            window#waybar.floating #window,
            window#waybar.tiled #window,
            window#waybar.stacked #window,
            window#waybar.swallowing #window,
            window#waybar.tabbed #window {
              background-color: ${colors.withHashtag.base00};
              color: ${colors.withHashtag.base05};
              font-weight: bold;
              padding-left: 0.7em;
              padding-right: 0.7em;
            }

            /* right module container */
            .modules-right {
              background-color: ${colors.withHashtag.base00};
              color: ${colors.withHashtag.base05};
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
              background-color: ${colors.withHashtag.base07};
              padding-left: 1em;
              padding-right: 1em;
            }

            #tray window {
              background-color: ${colors.withHashtag.base07};
            }

            /* pulseaudio */
            #pulseaudio {
              color: ${colors.withHashtag.base0E};
            }

            /* backlight */
            #backlight {
              color: ${colors.withHashtag.base05};
            }

            /* disk */
            #disk {
              color: ${colors.withHashtag.base0C};
            }

            /* cpu */
            #cpu {
              color: ${colors.withHashtag.base0A};
            }

            /* memory */
            #memory {
              color: ${colors.withHashtag.base0F};
            }

            /* battery */
            #battery {
              color: ${colors.withHashtag.base05};
            }

            #battery.warning {
              color: ${colors.withHashtag.base09};
            }

            #battery.critical {
              color: ${colors.withHashtag.base08};
            }

            /* clock */
            #clock {
              color: ${colors.withHashtag.base07};
            }
          '';
      };
    };
}
