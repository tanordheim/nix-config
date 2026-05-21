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
          bell = fa "F0F3";
          fan = fa "F863";
        };

        icon = g: g;

        nctHwmon = "/sys/devices/platform/nct6775.*/hwmon/hwmon*";
        cpuHwmon = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon*";
        gpuHwmon = "/sys/devices/pci0000:00/0000:00:01.1/0000:01:00.0/0000:02:00.0/0000:03:00.0/hwmon/hwmon*";

        fansScript = pkgs.writeShellScript "waybar-fans" ''
          set -eu
          nct=$(echo ${nctHwmon})
          gpu=$(echo ${gpuHwmon})
          f1=$(cat "$nct/fan1_input")
          f2=$(cat "$nct/fan2_input")
          f3=$(cat "$nct/fan3_input")
          fg=$(cat "$gpu/fan1_input")
          top=$(printf '%s\n' "$f1" "$f2" "$f3" "$fg" | sort -n | tail -1)
          tt=$(printf 'GPU: %s rpm\nFan 1: %s rpm\nFan 2: %s rpm\nFan 3: %s rpm' "$fg" "$f1" "$f2" "$f3")
          ${pkgs.jq}/bin/jq -nc --arg text "$top" --arg tt "$tt" '{text: $text, tooltip: $tt}'
        '';

        tempCpuScript = pkgs.writeShellScript "waybar-temp-cpu" ''
          set -eu
          cpu=$(echo ${cpuHwmon})
          nct=$(echo ${nctHwmon})
          t=$(($(cat "$cpu/temp1_input") / 1000))
          f1=$(cat "$nct/fan1_input")
          f2=$(cat "$nct/fan2_input")
          f3=$(cat "$nct/fan3_input")
          cls=""
          [ "$t" -ge 85 ] && cls="critical"
          tt=$(printf 'CPU: %s°C\nFan 1: %s rpm\nFan 2: %s rpm\nFan 3: %s rpm' "$t" "$f1" "$f2" "$f3")
          ${pkgs.jq}/bin/jq -nc --arg text "$t" --arg tt "$tt" --arg cls "$cls" '{text: $text, tooltip: $tt, class: $cls}'
        '';

        tempGpuScript = pkgs.writeShellScript "waybar-temp-gpu" ''
          set -eu
          gpu=$(echo ${gpuHwmon})
          t=$(($(cat "$gpu/temp2_input") / 1000))
          fg=$(cat "$gpu/fan1_input")
          cls=""
          [ "$t" -ge 95 ] && cls="critical"
          tt=$(printf 'GPU: %s°C\nFan: %s rpm' "$t" "$fg")
          ${pkgs.jq}/bin/jq -nc --arg text "$t" --arg tt "$tt" --arg cls "$cls" '{text: $text, tooltip: $tt, class: $cls}'
        '';

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
              "DP-2" = [
                1
                2
                3
                4
                5
              ];
              "DP-1" = [
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
            mainBar =
              commonBar
              // sharedModules
              // {
                output = [ "DP-2" ];

                modules-left = [
                  "group/left-workspaces"
                  "mpris"
                  "group/left-status"
                  "custom/voxtype"
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
                  modules = [
                    "idle_inhibitor"
                    "tray"
                  ];
                };
                "group/center-window" = {
                  orientation = "horizontal";
                  modules = [ "hyprland/window" ];
                };
                "group/right-system" = {
                  orientation = "horizontal";
                  modules = [
                    "custom/fans"
                    "cpu"
                    "memory"
                    "disk"
                    "custom/temp-cpu"
                    "custom/temp-gpu"
                    "temperature#nvme"
                    "temperature#dimm"
                  ];
                };
                "group/right-conn" = {
                  orientation = "horizontal";
                  modules = [
                    "wireplumber"
                    "bluetooth"
                    "network"
                  ];
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
                  icon-size = 16;
                  spacing = 10;
                };

                cpu = {
                  format = "${icon glyph.cpu} {usage}%";
                  interval = 5;
                  tooltip-format = "CPU: {usage}%";
                };
                memory = {
                  format = "${icon glyph.memory} {percentage}%";
                  interval = 5;
                  tooltip-format = "Memory: {used:0.1f}G / {total:0.1f}G ({percentage}%)";
                };
                disk = {
                  format = "${icon glyph.disk} {percentage_used}%";
                  path = "/";
                  interval = 30;
                  tooltip-format = "Disk (/): {used} / {total} ({percentage_used}%)";
                };

                "custom/temp-cpu" = {
                  exec = "${tempCpuScript}";
                  return-type = "json";
                  interval = 5;
                  format = "${icon glyph.temp} {}°";
                };
                "custom/temp-gpu" = {
                  exec = "${tempGpuScript}";
                  return-type = "json";
                  interval = 5;
                  format = "${icon glyph.gpu} {}°";
                };
                "custom/fans" = {
                  exec = "${fansScript}";
                  return-type = "json";
                  interval = 5;
                  format = "${icon glyph.fan} {} rpm";
                };
                "temperature#nvme" = {
                  hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:02.2/0000:0c:00.0/nvme/nvme0";
                  input-filename = "temp1_input";
                  critical-threshold = 70;
                  format = "${icon glyph.nvme} {temperatureC}°";
                  tooltip-format = "NVMe: {temperatureC}°C";
                };
                "temperature#dimm" = {
                  hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:14.0/i2c-0/0-0053/hwmon";
                  input-filename = "temp1_input";
                  critical-threshold = 75;
                  format = "${icon glyph.dimm} {temperatureC}°";
                  tooltip-format = "DIMM: {temperatureC}°C";
                };

                wireplumber = {
                  format = "${icon glyph.volume} {volume}%";
                  format-muted = "${icon glyph.mute} muted";
                  tooltip-format = "Volume: {volume}% ({node_name})";
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
                  interval = 2;
                  format-wifi = "${icon glyph.wifi} {essid}";
                  format-ethernet = "${icon glyph.ethernet} {ifname}";
                  format-disconnected = "${icon glyph.wifiOff} disconnected";
                  tooltip-format = "{ifname}: {ipaddr}\n↓ {bandwidthDownBytes}/s  ↑ {bandwidthUpBytes}/s";
                  on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
                };

                "custom/voxtype" = {
                  exec = "${pkgs.voxtype}/bin/voxtype status --follow --format json";
                  return-type = "json";
                  format = "{} {alt}";
                  tooltip = true;
                  on-click = "${pkgs.voxtype}/bin/voxtype record toggle";
                };

                "custom/notification" = {
                  tooltip = false;
                  format = "${glyph.bell}{icon}";
                  format-icons = {
                    notification = "<span foreground='red'><sup>●</sup></span>";
                    none = "";
                    dnd-notification = "<span foreground='red'><sup>●</sup></span>";
                    dnd-none = "";
                    inhibited-notification = "<span foreground='red'><sup>●</sup></span>";
                    inhibited-none = "";
                    dnd-inhibited-notification = "<span foreground='red'><sup>●</sup></span>";
                    dnd-inhibited-none = "";
                  };
                  return-type = "json";
                  exec = "${swayncClient} -swb";
                  on-click = "${swayncClient} -t -sw";
                  on-click-right = "${swayncClient} -d -sw";
                  escape = true;
                };
              };

            secondaryBar =
              commonBar
              // sharedModules
              // {
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
            #mpris,
            #custom-voxtype {
              background: ${c.base00};
              border-radius: 8px;
              padding: 0 10px;
              margin: 2px 4px;
            }

            #custom-voxtype.recording {
              background: ${c.base08};
              color: ${c.base00};
            }

            #custom-voxtype.transcribing {
              background: ${c.base0E};
              color: ${c.base00};
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
            #custom-notification,
            #custom-temp-cpu,
            #custom-temp-gpu,
            #custom-fans {
              padding: 0 6px;
              color: ${c.base05};
            }

            #temperature.critical,
            #custom-temp-cpu.critical,
            #custom-temp-gpu.critical,
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
