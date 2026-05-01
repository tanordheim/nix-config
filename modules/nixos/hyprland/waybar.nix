{
  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      let
        c = config.lib.stylix.colors.withHashtag;

        playerctl = "${pkgs.playerctl}/bin/playerctl";
        swayncClient = "${pkgs.swaynotificationcenter}/bin/swaync-client";

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
                "group/left-media"
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
              "group/left-media" = {
                orientation = "horizontal";
                modules = [
                  "mpris"
                  "custom/media-prev"
                  "custom/media-pause"
                  "custom/media-next"
                ];
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
                  default = "▶";
                  spotify = "";
                };
                status-icons = {
                  paused = "⏸";
                  playing = "▶";
                  stopped = "⏹";
                };
                dynamic-len = 30;
              };

              "custom/media-prev" = {
                format = "{}";
                exec = ''${playerctl} -l 2>/dev/null | grep -q . && echo "⏮" || echo ""'';
                interval = 2;
                tooltip = false;
                on-click = "${playerctl} previous";
              };
              "custom/media-pause" = {
                format = "{}";
                exec = ''${playerctl} -l 2>/dev/null | grep -q . && echo "⏯" || echo ""'';
                interval = 2;
                tooltip = false;
                on-click = "${playerctl} play-pause";
              };
              "custom/media-next" = {
                format = "{}";
                exec = ''${playerctl} -l 2>/dev/null | grep -q . && echo "⏭" || echo ""'';
                interval = 2;
                tooltip = false;
                on-click = "${playerctl} next";
              };

              idle_inhibitor = {
                format = "{icon}";
                format-icons = {
                  activated = "⚡";
                  deactivated = "⏾";
                };
              };

              tray = {
                icon-size = 18;
                spacing = 10;
              };

              cpu = {
                format = " {usage}%";
                interval = 5;
              };
              memory = {
                format = " {percentage}%";
                interval = 5;
              };
              disk = {
                format = "󰋊 {percentage_used}%";
                path = "/";
                interval = 30;
              };

              "temperature#cpu" = {
                hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
                input-filename = "temp1_input";
                critical-threshold = 85;
                format = " {temperatureC}°";
                tooltip = false;
              };
              "temperature#gpu" = {
                hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:01.1/0000:01:00.0/0000:02:00.0/0000:03:00.0/hwmon";
                input-filename = "temp2_input";
                critical-threshold = 95;
                format = "󰢮 {temperatureC}°";
                tooltip = false;
              };
              "temperature#nvme" = {
                hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:02.2/0000:0c:00.0/nvme/nvme0/hwmon";
                input-filename = "temp1_input";
                critical-threshold = 70;
                format = " {temperatureC}°";
                tooltip = false;
              };
              "temperature#dimm" = {
                hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:14.0/i2c-0/0-0053/hwmon";
                input-filename = "temp1_input";
                critical-threshold = 75;
                format = " {temperatureC}°";
                tooltip = false;
              };

              wireplumber = {
                format = " {volume}%";
                format-muted = " muted";
                on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
              };

              bluetooth = {
                format = " {status}";
                format-disabled = " off";
                format-connected = " {device_alias}";
                tooltip-format = "{controller_alias}\n{num_connections} connected";
                on-click = "${pkgs.blueman}/bin/blueman-manager";
              };

              network = {
                format-wifi = " {essid}";
                format-ethernet = "󰈀 {ifname}";
                format-disconnected = "󰖪 disconnected";
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
            #left-media,
            #left-status,
            #center-window,
            #right-system,
            #right-conn,
            #right-notif,
            #right-clock {
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
            #mpris,
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
            #custom-notification,
            #custom-media-prev,
            #custom-media-pause,
            #custom-media-next {
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
