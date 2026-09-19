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
        workspaceBinds = lib.listToAttrs (
          map (n: lib.nameValuePair "Mod+${toString n}" { focus-workspace = n; }) (lib.range 1 9)
        );
        screenshotRegion = pkgs.writeShellApplication {
          name = "niri-screenshot-region";
          runtimeInputs = [
            pkgs.slurp
            pkgs.grim
            pkgs.wl-clipboard
          ];
          text = ''
            geometry=$(slurp)
            grim -g "$geometry" - | wl-copy --type image/png
          '';
        };
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
              gaps = 12;
              center-focused-column = "always";
              default-column-width.proportion = 0.33333;
              preset-column-widths._children = [
                { proportion = 0.33333; }
                { proportion = 0.5; }
                { proportion = 0.66667; }
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
              tab-indicator = {
                position = "top";
                place-within-column = { };
                width = 8;
                gap = 6;
                length._props.total-proportion = 1.0;
                gaps-between-tabs = 6;
                corner-radius = 4;
                active-color = colors.base0E;
                inactive-color = colors.base04;
                urgent-color = colors.base08;
              };
            };

            gestures.hot-corners.off = { };

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
              { workspace._args = [ "comms" ]; }
              {
                workspace = {
                  _args = [ "wow" ];
                  layout.struts = {
                    top = 119;
                    bottom = 120;
                  };
                };
              }
              {
                window-rule = {
                  match._props = {
                    app-id = "^steam_app_default$";
                    title = "^World of Warcraft$";
                  };
                  open-on-workspace = "wow";
                  open-fullscreen = false;
                  default-column-width.fixed = 2880;
                  min-width = 2880;
                  max-width = 2880;
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
                  _args = [ "Dell Inc. DELL U5226KW 4CVCKJ4" ];
                  mode = "6144x2560@119.996";
                  scale = 1.333333;
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

            binds = workspaceBinds // {
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
              "Mod+Shift+I".move-column-to-workspace-up = { };
              "Mod+Shift+U".move-column-to-workspace-down = { };
              "Mod+Ctrl+I".move-workspace-up = { };
              "Mod+Ctrl+U".move-workspace-down = { };
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
              "Mod+Shift+S" = {
                _props = {
                  repeat = false;
                  hotkey-overlay-title = "Copy screen region";
                };
                spawn = [ (lib.getExe screenshotRegion) ];
              };
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
