{
  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      let
        c = config.lib.stylix.colors.withHashtag;
        f = config.stylix.fonts;

        themeQml = pkgs.writeText "Theme.qml" ''
          pragma Singleton

          import QtQuick
          import Quickshell

          Singleton {
              readonly property color base00: "${c.base00}"
              readonly property color base01: "${c.base01}"
              readonly property color base02: "${c.base02}"
              readonly property color base03: "${c.base03}"
              readonly property color base04: "${c.base04}"
              readonly property color base05: "${c.base05}"
              readonly property color base06: "${c.base06}"
              readonly property color base07: "${c.base07}"
              readonly property color base08: "${c.base08}"
              readonly property color base09: "${c.base09}"
              readonly property color base0A: "${c.base0A}"
              readonly property color base0B: "${c.base0B}"
              readonly property color base0C: "${c.base0C}"
              readonly property color base0D: "${c.base0D}"
              readonly property color base0E: "${c.base0E}"
              readonly property color base0F: "${c.base0F}"

              readonly property color background: base00
              readonly property color surface: base01
              readonly property color hoverSurface: base02
              readonly property color separator: base03
              readonly property color mutedText: base04
              readonly property color text: base05
              readonly property color critical: base08
              readonly property color warning: base0A
              readonly property color success: base0B
              readonly property color accent: base0E

              readonly property string fontFamily: "${f.monospace.name}"
              readonly property int fontSize: 13
              readonly property int fontSizeSmall: 11
              readonly property int fontSizeBadge: 9
              readonly property int iconSize: 16
              readonly property int iconSizeLarge: 24

              readonly property int spacingSmall: 4
              readonly property int spacingNormal: 8
              readonly property int spacingLarge: 12

              readonly property int barHeight: 32
              readonly property int bulletSize: 8
              readonly property int bulletActiveSize: 12
              readonly property int bulletSlot: 18
              readonly property int radius: 8
              readonly property int badgeSize: 14
              readonly property int dotSize: 6

              readonly property int popoutGap: 4
              readonly property int popoutPadding: 12
              readonly property int popoutRadius: 12
              readonly property int popoutWidth: 300
              readonly property int popoutWidthWide: 480
              readonly property int rowHeight: 26
              readonly property int sliderWidth: 160
              readonly property int sliderHeight: 6
              readonly property int artworkSize: 64
              readonly property int textColumnWidth: 220
              readonly property int calendarCell: 30

              readonly property int histogramWidth: 180
              readonly property int histogramHeight: 22
              readonly property int histogramGap: 1
              readonly property int labelColumnWidth: 64
              readonly property int valueColumnWidth: 44
              readonly property int tempColumnWidth: 56
              readonly property int detailColumnWidth: 110

              readonly property real dimOpacity: 0.4

              readonly property int animationFast: 120
              readonly property int animationSlow: 600
              readonly property int hoverDelay: 400
              readonly property int hoverGrace: 250
          }
        '';

        themeDir = pkgs.runCommand "quickshell-theme" { } ''
          mkdir -p $out/theme
          cp ${themeQml} $out/theme/Theme.qml
        '';

        configQml = pkgs.writeText "Config.qml" ''
          pragma Singleton

          import Quickshell

          Singleton {
              readonly property string primaryMonitor: "DP-2"
              readonly property string shell: "${pkgs.runtimeShell}"

              readonly property list<string> voxtypeStatus: ["${pkgs.voxtype}/bin/voxtype", "status", "--follow", "--format", "json"]
              readonly property list<string> voxtypeToggle: ["${pkgs.voxtype}/bin/voxtype", "record", "toggle"]
              readonly property list<string> swayncStream: ["${pkgs.swaynotificationcenter}/bin/swaync-client", "-swb"]
              readonly property list<string> swayncToggleCenter: ["${pkgs.swaynotificationcenter}/bin/swaync-client", "-t", "-sw"]
              readonly property list<string> swayncToggleDnd: ["${pkgs.swaynotificationcenter}/bin/swaync-client", "-d", "-sw"]
              readonly property list<string> audioSettings: ["${pkgs.pavucontrol}/bin/pavucontrol"]
              readonly property list<string> bluetoothSettings: ["${pkgs.blueman}/bin/blueman-manager"]
              readonly property list<string> networkSettings: ["${pkgs.networkmanagerapplet}/bin/nm-connection-editor"]
              readonly property list<string> diskUsage: ["${pkgs.coreutils}/bin/df", "-B1", "--output=used,size", "/"]
              readonly property list<string> topProcessesByCpu: ["${pkgs.runtimeShell}", "-c", "${pkgs.procps}/bin/ps -eo pcpu,pmem,comm --no-headers --sort=-pcpu | ${pkgs.coreutils}/bin/head -n 5"]
              readonly property list<string> topProcessesByMemory: ["${pkgs.runtimeShell}", "-c", "${pkgs.procps}/bin/ps -eo pcpu,pmem,comm --no-headers --sort=-pmem | ${pkgs.coreutils}/bin/head -n 5"]
              readonly property string ipBinary: "${pkgs.iproute2}/bin/ip"

              readonly property string gpuBusyPath: "/sys/devices/pci0000:00/0000:00:01.1/0000:01:00.0/0000:02:00.0/0000:03:00.0/gpu_busy_percent"
              readonly property string cpuHwmonGlob: "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon*"
              readonly property string gpuHwmonGlob: "/sys/devices/pci0000:00/0000:00:01.1/0000:01:00.0/0000:02:00.0/0000:03:00.0/hwmon/hwmon*"
              readonly property string nctHwmonGlob: "/sys/devices/platform/nct6775.*/hwmon/hwmon*"
              readonly property string nvmeHwmonGlob: "/sys/devices/pci0000:00/0000:00:02.2/0000:0c:00.0/nvme/nvme0/hwmon*"
              readonly property string dimmHwmonGlob: "/sys/devices/pci0000:00/0000:00:14.0/i2c-0/0-0053/hwmon/hwmon*"

              readonly property string networkStatistics: "/sys/class/net"
              readonly property string routeTable: "/proc/net/route"
              readonly property string resolvConf: "/etc/resolv.conf"
          }
        '';

        configDir = pkgs.runCommand "quickshell-config-constants" { } ''
          mkdir -p $out/config
          cp ${configQml} $out/config/Config.qml
        '';

        shellConfig = pkgs.symlinkJoin {
          name = "quickshell-nix-config";
          paths = [
            ./quickshell
            themeDir
            configDir
          ];
        };
      in
      {
        programs.quickshell = {
          enable = true;
          package = pkgs.quickshell;
          configs.nix-config = shellConfig;
          activeConfig = "nix-config";
          systemd.enable = true;
        };

        systemd.user.services.quickshell = {
          Unit = {
            PartOf = [ "graphical-session.target" ];
            ConditionEnvironment = "WAYLAND_DISPLAY";
            StartLimitIntervalSec = 60;
            StartLimitBurst = 5;
            X-Restart-Triggers = [ "${shellConfig}" ];
          };
          Service = {
            Slice = "session.slice";
            RestartSec = 2;
          };
        };
      }
    )
  ];
}
