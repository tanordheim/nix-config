{
  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        colors = config.lib.stylix.colors.withHashtag;
      in
      {
        wayland.windowManager.niri = {
          enable = true;
          package = pkgs.niri;
          systemd.enable = false;
          portalPackage = null;
          settings = {
            input.keyboard = {
              xkb = {
                layout = "no";
                variant = "nodeadkeys";
              };
              numlock = { };
              repeat-rate = 50;
              repeat-delay = 250;
            };

            cursor = {
              xcursor-theme = config.stylix.cursor.name;
              xcursor-size = config.stylix.cursor.size;
            };

            environment = {
              QT_QPA_PLATFORMTHEME = "qt5ct";
              GSK_RENDERER = "gl";
            };

            layout = {
              gaps = 10;
              center-focused-column = "never";
              always-center-single-column = { };
              default-column-width.proportion = 0.5;
              preset-column-widths._children = [
                { proportion = 0.25; }
                { proportion = 0.33333; }
                { proportion = 0.5; }
                { proportion = 1.0; }
              ];
              focus-ring.off = { };
              border = {
                on = { };
                width = 2;
                active-color = colors.base0E;
                inactive-color = colors.base03;
                urgent-color = colors.base08;
              };
              shadow = {
                on = { };
                softness = 4;
                spread = 0;
                offset._props = {
                  x = 0;
                  y = 0;
                };
                color = "${colors.base00}99";
              };
            };

            workspace._args = [ "comms" ];

            prefer-no-csd = { };
            screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

            _children = [
              {
                window-rule = {
                  _children = map (appId: { match._props.app-id = "^${lib.escapeRegex appId}$"; }) [
                    "slack"
                    "discord"
                    "teams-for-linux"
                    "signal"
                    "org.telegram.desktop"
                    "com.github.dagmoller.whatsapp-electron"
                  ];
                  open-on-workspace = "comms";
                };
              }
              {
                window-rule = {
                  match._props.app-id = "^firefox$";
                  open-maximized-to-edges = false;
                };
              }
              {
                output = {
                  _args = [ "DP-1" ];
                  off = { };
                };
              }
              {
                output = {
                  _args = [ "DP-2" ];
                  mode = "3440x1440@180";
                  scale = 1;
                  position._props = {
                    x = 0;
                    y = 0;
                  };
                };
              }
              {
                window-rule = {
                  geometry-corner-radius = 5;
                  clip-to-geometry = true;
                  background-effect = {
                    blur = true;
                    xray = false;
                  };
                };
              }
            ];

            binds = {
              "Mod+T" = {
                _props = {
                  repeat = false;
                  hotkey-overlay-title = "Open Ghostty";
                };
                spawn = [
                  "${pkgs.ghostty}/bin/ghostty"
                  "--working-directory=${config.home.homeDirectory}"
                ];
              };
              "Mod+D" = {
                _props = {
                  repeat = false;
                  hotkey-overlay-title = "Open Fuzzel";
                };
                spawn = [ "${pkgs.fuzzel}/bin/fuzzel" ];
              };
              "Mod+E" = {
                _props = {
                  repeat = false;
                  hotkey-overlay-title = "Open Thunar";
                };
                spawn = [ "${pkgs.thunar}/bin/thunar" ];
              };
              "Mod+Q".close-window = { };
              "Mod+H".focus-column-left = { };
              "Mod+L".focus-column-right = { };
              "Mod+K".focus-window-up = { };
              "Mod+J".focus-window-down = { };
              "Mod+Ctrl+H".move-column-left = { };
              "Mod+Ctrl+L".move-column-right = { };
              "Mod+Ctrl+K".move-window-up = { };
              "Mod+Ctrl+J".move-window-down = { };
              "Mod+Shift+H".consume-or-expel-window-left = { };
              "Mod+Shift+L".consume-or-expel-window-right = { };
              "Mod+I".focus-workspace-up = { };
              "Mod+U".focus-workspace-down = { };
              "Mod+Ctrl+I".move-column-to-workspace-up = { };
              "Mod+Ctrl+U".move-column-to-workspace-down = { };
              "Mod+Tab".focus-workspace-previous = { };
              "Mod+C".focus-workspace = "comms";
              "Mod+R".switch-preset-column-width = { };
              "Mod+Shift+R".switch-preset-column-width-back = { };
              "Mod+F".maximize-column = { };
              "Mod+Ctrl+F".expand-column-to-available-width = { };
              "Mod+M".maximize-window-to-edges = { };
              "Mod+Shift+F".fullscreen-window = { };
              "Mod+V".toggle-window-floating = { };
              "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };
              "Mod+W".toggle-column-tabbed-display = { };
              "Mod+O" = {
                _props.repeat = false;
                toggle-overview = { };
              };
              "Mod+Shift+S".screenshot = { };
              "Mod+F1".show-hotkey-overlay = { };
              "Mod+Shift+E".quit = { };

              "XF86AudioRaiseVolume".spawn = [
                "${pkgs.wireplumber}/bin/wpctl"
                "set-volume"
                "-l"
                "1.0"
                "@DEFAULT_AUDIO_SINK@"
                "5%+"
              ];
              "XF86AudioLowerVolume".spawn = [
                "${pkgs.wireplumber}/bin/wpctl"
                "set-volume"
                "-l"
                "1.0"
                "@DEFAULT_AUDIO_SINK@"
                "5%-"
              ];
              "XF86AudioMute".spawn = [
                "${pkgs.wireplumber}/bin/wpctl"
                "set-mute"
                "@DEFAULT_AUDIO_SINK@"
                "toggle"
              ];
              "XF86AudioPlay".spawn = [
                "${pkgs.playerctl}/bin/playerctl"
                "play-pause"
              ];
              "XF86AudioPause".spawn = [
                "${pkgs.playerctl}/bin/playerctl"
                "play-pause"
              ];
              "XF86AudioNext".spawn = [
                "${pkgs.playerctl}/bin/playerctl"
                "next"
              ];
              "XF86AudioPrev".spawn = [
                "${pkgs.playerctl}/bin/playerctl"
                "previous"
              ];
            };
          };
        };
      }
    )
  ];
}
