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

              readonly property int spacingSmall: 4
              readonly property int spacingNormal: 8
              readonly property int spacingLarge: 12

              readonly property int barHeight: 32
              readonly property int bulletSize: 8
              readonly property int bulletActiveSize: 12
              readonly property int bulletSlot: 18
              readonly property int radius: 8

              readonly property real dimOpacity: 0.4

              readonly property int animationFast: 120
              readonly property int animationSlow: 600
          }
        '';

        themeDir = pkgs.runCommand "quickshell-theme" { } ''
          mkdir -p $out/theme
          cp ${themeQml} $out/theme/Theme.qml
        '';

        shellConfig = pkgs.symlinkJoin {
          name = "quickshell-nix-config";
          paths = [
            ./quickshell
            themeDir
          ];
        };
      in
      {
        programs.quickshell = {
          enable = true;
          package = pkgs.quickshell;
          configs.nix-config = shellConfig;
          activeConfig = "nix-config";
          systemd.enable = false;
        };
      }
    )
  ];
}
