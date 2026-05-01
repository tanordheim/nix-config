{
  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      let
        c = config.lib.stylix.colors.withHashtag;

        playerctl = "${pkgs.playerctl}/bin/playerctl";
        swayncClient = "${pkgs.swaynotificationcenter}/bin/swaync-client";

        fa = code: builtins.fromJSON ''"\u${code}"'';

        glyph = {
          cpu = fa "F4BC";
          memory = fa "F2DB";
          disk = "󰋊";
          temp = fa "F2C9";
          gpu = "󰢮";
          nvme = fa "F0A0";
          dimm = fa "F2DB";
          volume = fa "F028";
          mute = fa "F026";
          wifi = fa "F1EB";
          ethernet = "󰈀";
          wifiOff = "󰖪";
          bluetooth = fa "F293";
          bolt = fa "F0E7";
          moon = fa "F186";
          play = fa "F04B";
          pause = fa "F04C";
          stop = fa "F04D";
          spotify = fa "F1BC";
        };

        icon = g: "<span size='large'>${g}</span>";

        commonBar = {
          layer = "top";
          position = "top";
          height = 30;
          margin-top = 5;
          margin-left = 5;
          margin-right = 5;
          margin-bottom = 0;
          spacing = 10;
          reload_style_on_change = true;
        };

        sharedModules = {
          "hyprland/workspaces" = {
            all-outputs = false;
            persistent-workspaces = {
              "DP-2" = [ 1 2 3 4 5 ];
              "DP-1" = [ 6 7 8 9 10 ];
            };
          };

          "hyprland/window" = {
            max-length = 75;
            separate-outputs = true;
          };

          clock = {
            format = "{:%H:%M · %b %d}";
            format-alt = "{:%H:%M:%S}";
            tooltip-format = "<tt><big>{calendar}</big></tt>";
            calendar = {
              mode = "month";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
            };
          };
        };
      in
      {
        stylix.targets.waybar.enable = false;

        programs.waybar = {
          enable = true;
          systemd.enable = true;

          settings = {
            mainBar = commonBar // sharedModules // {
              output = [ "DP-2" ];

              modules-left = [
                "group/left-workspaces"
                "mpris"
                "group/left-status"
              ];
              modules-center = [ "group/center-window" ];
              modules-right = [
                "group/right-system"
                "group/right-conn"
                "group/right-notif"
                "group/right-clock"
              ];

              "group/left-workspaces" = {
                orientation = "horizontal";
                modules = [ "hyprland/workspaces" ];
              };
              "group/left-status" = {
                orientation = "horizontal";
                modules = [ "idle_inhibitor" "tray" ];
              };
              "group/center-window" = {
                orientation = "horizontal";
                modules = [ "hyprland/window" ];
              };
              "group/right-system" = {
                orientation = "horizontal";
                modules = [
                  "cpu"
                  "memory"
                  "disk"
                  "temperature#cpu"
                  "temperature#gpu"
                  "temperature#nvme"
                  "temperature#dimm"
                ];
              };
              "group/right-conn" = {
                orientation = "horizontal";
                modules = [ "wireplumber" "bluetooth" "network" ];
              };
              "group/right-notif" = {
                orientation = "horizontal";
                modules = [ "custom/notification" ];
              };
              "group/right-clock" = {
                orientation = "horizontal";
                modules = [ "clock" ];
              };

              mpris = {
                format = "{player_icon} {dynamic}";
                format-paused = "{status_icon} <i>{dynamic}</i>";
                player-icons = {
                  default = icon glyph.play;
                  spotify = icon glyph.spotify;
                };
                status-icons = {
                  paused = icon glyph.pause;
                  playing = icon glyph.play;
                  stopped = icon glyph.stop;
                };
                dynamic-len = 30;
              };

              idle_inhibitor = {
                format = "{icon}";
                format-icons = {
                  activated = icon glyph.bolt;
                  deactivated = icon glyph.moon;
                };
              };

              tray = {
                icon-size = 18;
                spacing = 10;
              };

              cpu = {
                format = "${icon glyph.cpu} {usage}%";
                interval = 5;
              };
              memory = {
                format = "${icon glyph.memory} {percentage}%";
                interval = 5;
              };
              disk = {
                format = "${icon glyph.disk} {percentage_used}%";
                path = "/";
                interval = 30;
              };

              "temperature#cpu" = {
                hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
                input-filename = "temp1_input";
                critical-threshold = 85;
                format = "${icon glyph.temp} {temperatureC}°";
                tooltip = false;
              };
              "temperature#gpu" = {
                hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:01.1/0000:01:00.0/0000:02:00.0/0000:03:00.0/hwmon";
                input-filename = "temp2_input";
                critical-threshold = 95;
                format = "${icon glyph.gpu} {temperatureC}°";
                tooltip = false;
              };
              "temperature#nvme" = {
                hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:02.2/0000:0c:00.0/nvme/nvme0/hwmon";
                input-filename = "temp1_input";
                critical-threshold = 70;
                format = "${icon glyph.nvme} {temperatureC}°";
                tooltip = false;
              };
              "temperature#dimm" = {
                hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:14.0/i2c-0/0-0053/hwmon";
                input-filename = "temp1_input";
                critical-threshold = 75;
                format = "${icon glyph.dimm} {temperatureC}°";
                tooltip = false;
              };

              wireplumber = {
                format = "${icon glyph.volume} {volume}%";
                format-muted = "${icon glyph.mute} muted";
                on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
              };

              bluetooth = {
                format = "${icon glyph.bluetooth} {status}";
                format-disabled = "${icon glyph.bluetooth} off";
                format-connected = "${icon glyph.bluetooth} {device_alias}";
                tooltip-format = "{controller_alias}\n{num_connections} connected";
                on-click = "${pkgs.blueman}/bin/blueman-manager";
              };

              network = {
                format-wifi = "${icon glyph.wifi} {essid}";
                format-ethernet = "${icon glyph.ethernet} {ifname}";
                format-disconnected = "${icon glyph.wifiOff} disconnected";
                tooltip-format = "{ifname}: {ipaddr}";
                on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
              };

              "custom/notification" = {
                tooltip = false;
                format = "{icon}";
                format-icons = {
                  notification = "<span foreground='red'><sup></sup></span>";
                  none = "";
                  dnd-notification = "<span foreground='red'><sup></sup></span>";
                  dnd-none = "";
                  inhibited-notification = "<span foreground='red'><sup></sup></span>";
                  inhibited-none = "";
                  dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
                  dnd-inhibited-none = "";
                };
                return-type = "json";
                exec = "${swayncClient} -swb";
                on-click = "${swayncClient} -t -sw";
                on-click-right = "${swayncClient} -d -sw";
                escape = true;
              };
            };

            secondaryBar = commonBar // sharedModules // {
              output = [ "DP-1" ];

              modules-left = [ "group/left-workspaces" ];
              modules-center = [ "group/center-window" ];
              modules-right = [ "group/right-clock" ];

              "group/left-workspaces" = {
                orientation = "horizontal";
                modules = [ "hyprland/workspaces" ];
              };
              "group/center-window" = {
                orientation = "horizontal";
                modules = [ "hyprland/window" ];
              };
              "group/right-clock" = {
                orientation = "horizontal";
                modules = [ "clock" ];
              };
            };
          };

          style = ''
            * {
              border: none;
              border-radius: 0;
              font-family: "Aporetic Sans Mono", "Symbols Nerd Font Mono", "JetBrainsMono Nerd Font";
              font-size: 13px;
              min-height: 0;
            }

            window#waybar {
              background: transparent;
              color: ${c.base05};
            }

            #left-workspaces,
            #left-status,
            #center-window,
            #right-system,
            #right-conn,
            #right-notif,
            #right-clock,
            #mpris {
              background: ${c.base00};
              border-radius: 8px;
              padding: 0 10px;
              margin: 2px 4px;
            }

            #workspaces button {
              padding: 0 8px;
              margin: 2px 2px;
              color: ${c.base05};
              background: transparent;
              border-radius: 6px;
            }

            #workspaces button.active {
              background: ${c.base0E};
              color: ${c.base00};
            }

            #workspaces button:hover {
              background: ${c.base02};
              color: ${c.base05};
            }

            #window,
            #cpu,
            #memory,
            #disk,
            #temperature,
            #wireplumber,
            #bluetooth,
            #network,
            #idle_inhibitor,
            #tray,
            #clock,
            #custom-notification {
              padding: 0 6px;
              color: ${c.base05};
            }

            #temperature.critical,
            #wireplumber.muted,
            #network.disconnected {
              color: ${c.base08};
            }
          '';
        };
      }
    )
  ];
}
