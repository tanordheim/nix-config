{
  home-manager.sharedModules = [
    (
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        colors = config.lib.stylix.colors;
        accent = "rgb(${colors.base0C})";
        muted = "rgb(${colors.base03})";
        locked = "rgb(${colors.base09})";
        fg = "rgb(${colors.base05})";
        bg = "rgb(${colors.base00})";
        inline = lib.generators.mkLuaInline;
        bind = keys: dispatcher: {
          _args = [
            keys
            (inline dispatcher)
          ];
        };
        bindMouse = keys: dispatcher: {
          _args = [
            keys
            (inline dispatcher)
            { mouse = true; }
          ];
        };
        modBind = suffix: bind (inline ''mainMod .. " + ${suffix}"'');
        modBindMouse = suffix: bindMouse (inline ''mainMod .. " + ${suffix}"'');
      in
      {
        stylix.targets.hyprland.enable = false;

        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = false;
          package = pkgs.hyprland;
          portalPackage = pkgs.xdg-desktop-portal-hyprland;
          settings = {
            mainMod = {
              _var = "ALT";
            };

            config = {
              general = {
                gaps_in = 5;
                gaps_out = 10;
                border_size = 2;
                layout = "master";
                allow_tearing = false;
                "col.active_border" = accent;
                "col.inactive_border" = muted;
              };

              decoration = {
                active_opacity = 1;
                fullscreen_opacity = 1;
                inactive_opacity = 1;
                dim_inactive = false;
                dim_strength = 0.2;
                rounding = 5;
                blur = {
                  enabled = true;
                  size = 2;
                  passes = 2;
                  vibrancy = 0.1000;
                  ignore_opacity = true;
                  new_optimizations = true;
                };
                shadow = {
                  enabled = true;
                  range = 4;
                  render_power = 3;
                  color = "rgba(${colors.base00}99)";
                };
                glow = {
                  enabled = true;
                  range = 10;
                  render_power = 3;
                  color = "rgba(${colors.base0C}66)";
                  color_inactive = "rgba(${colors.base0C}00)";
                };
              };

              animations.enabled = true;

              dwindle = {
                preserve_split = true;
              };

              master.new_status = "slave";

              render = {
                direct_scanout = 0;
                cm_enabled = false;
              };

              misc = {
                force_default_wallpaper = 0;
                disable_hyprland_logo = true;
                animate_manual_resizes = true;
                mouse_move_enables_dpms = true;
                key_press_enables_dpms = true;
                middle_click_paste = false;
                vrr = 0;
                background_color = bg;
              };

              group = {
                "col.border_active" = accent;
                "col.border_inactive" = muted;
                "col.border_locked_active" = locked;
                groupbar = {
                  "col.active" = accent;
                  "col.inactive" = muted;
                  "text_color" = fg;
                };
              };

              input = {
                kb_layout = "no";
                kb_variant = "nodeadkeys";
                float_switch_override_focus = false;
                numlock_by_default = true;
                repeat_rate = 50;
                repeat_delay = 250;
                follow_mouse = false;
                focus_on_close = 2;
                sensitivity = 0;
              };
            };

            curve = [
              {
                _args = [
                  "snappy"
                  {
                    type = "spring";
                    mass = 1;
                    stiffness = 150;
                    dampening = 22;
                  }
                ];
              }
            ];

            animation = [
              {
                leaf = "windows";
                enabled = true;
                speed = 7;
                spring = "snappy";
                style = "popin";
              }
              {
                leaf = "windowsOut";
                enabled = true;
                speed = 7;
                spring = "snappy";
                style = "popin";
              }
              {
                leaf = "border";
                enabled = true;
                speed = 10;
                bezier = "default";
              }
              {
                leaf = "fade";
                enabled = true;
                speed = 5;
                bezier = "default";
              }
              {
                leaf = "workspaces";
                enabled = true;
                speed = 2;
                bezier = "default";
              }
            ];

            env = [
              {
                _args = [
                  "QT_QPA_PLATFORMTHEME"
                  "qt5ct"
                ];
              }
              {
                _args = [
                  "GSK_RENDERER"
                  "gl"
                ];
              }
            ];

            monitor = [
              {
                output = "DP-1";
                mode = "2560x1440@155";
                position = "0x0";
                scale = 1;
                transform = 1;
              }
              {
                output = "DP-2";
                mode = "3440x1440@180";
                position = "1440x320";
                scale = 1;
              }
            ];

            workspace_rule = [
              {
                workspace = "1";
                monitor = "DP-2";
                default = true;
              }
              {
                workspace = "2";
                monitor = "DP-2";
              }
              {
                workspace = "3";
                monitor = "DP-2";
              }
              {
                workspace = "4";
                monitor = "DP-2";
              }
              {
                workspace = "5";
                monitor = "DP-2";
              }
              {
                workspace = "6";
                monitor = "DP-1";
                default = true;
                layout_opts = {
                  orientation = "top";
                };
              }
              {
                workspace = "7";
                monitor = "DP-1";
                layout_opts = {
                  orientation = "top";
                };
              }
              {
                workspace = "8";
                monitor = "DP-1";
                layout_opts = {
                  orientation = "top";
                };
              }
              {
                workspace = "9";
                monitor = "DP-1";
                layout_opts = {
                  orientation = "top";
                };
              }
              {
                workspace = "10";
                monitor = "DP-1";
                layout_opts = {
                  orientation = "top";
                };
              }
            ];

            window_rule = [
              {
                name = "diablo-render-unfocused";
                match = {
                  class = "^(diablo iv\\.exe)$";
                };
                render_unfocused = true;
                idle_inhibit = "always";
              }
              {
                name = "slack-ws6";
                match = {
                  class = "^(slack)$";
                };
                workspace = "6 silent";
              }
              {
                name = "telegram-ws6";
                match = {
                  class = "^(org\\.telegram\\.desktop)$";
                };
                workspace = "6 silent";
              }
              {
                name = "signal-ws7";
                match = {
                  class = "^(signal)$";
                };
                workspace = "7 silent";
              }
              {
                name = "whatsapp-ws7";
                match = {
                  class = "^(whatsapp-electron)$";
                };
                workspace = "7 silent";
              }
              {
                name = "teams-ws8";
                match = {
                  class = "^(electron)$";
                  title = "^(.*Microsoft Teams)$";
                };
                workspace = "8 silent";
              }
              {
                name = "spotify-ws9";
                match = {
                  class = "^(spotify)$";
                };
                workspace = "9 silent";
              }
              {
                name = "pocketcasts-ws9";
                match = {
                  class = "^(Electron)$";
                  title = "^(.*Pocket Casts)$";
                };
                workspace = "9 silent";
              }
              {
                name = "discord-ws8";
                match = {
                  class = "^(discord)$";
                };
                workspace = "8 silent";
              }
              {
                name = "tsm-magic";
                match = {
                  title = "^(TradeSkillMaster Application.*)$";
                };
                workspace = "special:magic silent";
              }
              {
                name = "explorer-hidden";
                match = {
                  class = "^(explorer\\.exe)$";
                  title = "^$";
                };
                workspace = "special:hidden silent";
              }
            ];

            bind = [
              (modBind "return" ''hl.dsp.exec_cmd("${pkgs.uwsm}/bin/uwsm app -- ${pkgs.ghostty}/bin/ghostty --working-directory=$HOME")'')
              (modBind "space" ''hl.dsp.exec_cmd("${pkgs.uwsm}/bin/uwsm app -- hyprlauncher")'')
              (modBind "E" ''hl.dsp.exec_cmd("${pkgs.uwsm}/bin/uwsm app -- thunar")'')
              (modBind "SHIFT + W" "hl.dsp.window.close()")
              (modBind "CTRL + SUPER + BackSpace" "hl.dsp.exit()")
              (modBind "CTRL + C" ''hl.dsp.exec_cmd("hyprctl reload")'')

              (bind "SUPER + h" ''hl.dsp.focus({ direction = "left" })'')
              (bind "SUPER + j" ''hl.dsp.focus({ direction = "down" })'')
              (bind "SUPER + k" ''hl.dsp.focus({ direction = "up" })'')
              (bind "SUPER + l" ''hl.dsp.focus({ direction = "right" })'')

              (bind "CTRL + SUPER + h" ''hl.dsp.window.move({ direction = "left" })'')
              (bind "CTRL + SUPER + j" ''hl.dsp.window.move({ direction = "down" })'')
              (bind "CTRL + SUPER + k" ''hl.dsp.window.move({ direction = "up" })'')
              (bind "CTRL + SUPER + l" ''hl.dsp.window.move({ direction = "right" })'')

              (modBind "SHIFT + 1" "hl.dsp.focus({ workspace = 1 })")
              (modBind "SHIFT + 2" "hl.dsp.focus({ workspace = 2 })")
              (modBind "SHIFT + 3" "hl.dsp.focus({ workspace = 3 })")
              (modBind "SHIFT + 4" "hl.dsp.focus({ workspace = 4 })")
              (modBind "SHIFT + 5" "hl.dsp.focus({ workspace = 5 })")
              (modBind "SHIFT + 6" "hl.dsp.focus({ workspace = 6 })")
              (modBind "SHIFT + 7" "hl.dsp.focus({ workspace = 7 })")
              (modBind "SHIFT + 8" "hl.dsp.focus({ workspace = 8 })")
              (modBind "SHIFT + 9" "hl.dsp.focus({ workspace = 9 })")
              (modBind "SHIFT + 0" "hl.dsp.focus({ workspace = 10 })")

              (modBind "SHIFT + KP_End" "hl.dsp.focus({ workspace = 1 })")
              (modBind "SHIFT + KP_Down" "hl.dsp.focus({ workspace = 2 })")
              (modBind "SHIFT + KP_Next" "hl.dsp.focus({ workspace = 3 })")
              (modBind "SHIFT + KP_Left" "hl.dsp.focus({ workspace = 4 })")
              (modBind "SHIFT + KP_Begin" "hl.dsp.focus({ workspace = 5 })")
              (modBind "SHIFT + KP_Right" "hl.dsp.focus({ workspace = 6 })")
              (modBind "SHIFT + KP_Home" "hl.dsp.focus({ workspace = 7 })")
              (modBind "SHIFT + KP_Up" "hl.dsp.focus({ workspace = 8 })")
              (modBind "SHIFT + KP_Prior" "hl.dsp.focus({ workspace = 9 })")
              (modBind "SHIFT + KP_Insert" "hl.dsp.focus({ workspace = 10 })")

              (modBind "CTRL + 1" "hl.dsp.window.move({ workspace = 1 })")
              (modBind "CTRL + 2" "hl.dsp.window.move({ workspace = 2 })")
              (modBind "CTRL + 3" "hl.dsp.window.move({ workspace = 3 })")
              (modBind "CTRL + 4" "hl.dsp.window.move({ workspace = 4 })")
              (modBind "CTRL + 5" "hl.dsp.window.move({ workspace = 5 })")
              (modBind "CTRL + 6" "hl.dsp.window.move({ workspace = 6 })")
              (modBind "CTRL + 7" "hl.dsp.window.move({ workspace = 7 })")
              (modBind "CTRL + 8" "hl.dsp.window.move({ workspace = 8 })")
              (modBind "CTRL + 9" "hl.dsp.window.move({ workspace = 9 })")
              (modBind "CTRL + 0" "hl.dsp.window.move({ workspace = 10 })")

              (modBind "CTRL + KP_End" "hl.dsp.window.move({ workspace = 1 })")
              (modBind "CTRL + KP_Down" "hl.dsp.window.move({ workspace = 2 })")
              (modBind "CTRL + KP_Next" "hl.dsp.window.move({ workspace = 3 })")
              (modBind "CTRL + KP_Left" "hl.dsp.window.move({ workspace = 4 })")
              (modBind "CTRL + KP_Begin" "hl.dsp.window.move({ workspace = 5 })")
              (modBind "CTRL + KP_Right" "hl.dsp.window.move({ workspace = 6 })")
              (modBind "CTRL + KP_Home" "hl.dsp.window.move({ workspace = 7 })")
              (modBind "CTRL + KP_Up" "hl.dsp.window.move({ workspace = 8 })")
              (modBind "CTRL + KP_Prior" "hl.dsp.window.move({ workspace = 9 })")
              (modBind "CTRL + KP_Insert" "hl.dsp.window.move({ workspace = 10 })")

              (modBind "Page_Down" ''hl.dsp.focus({ workspace = "e-1" })'')
              (modBind "Page_Up" ''hl.dsp.focus({ workspace = "e+1" })'')
              (modBind "Home" ''hl.dsp.focus({ workspace = "previous" })'')

              (modBind "SHIFT + S" ''hl.dsp.workspace.toggle_special("magic")'')
              (modBind "CTRL + S" ''hl.dsp.window.move({ workspace = "special:magic" })'')

              (modBind "CTRL + SHIFT + F" "hl.dsp.window.float()")
              (modBind "CTRL + SHIFT + T" ''hl.dsp.layout("togglesplit")'')

              (bind "SUPER + SHIFT + F" "hl.dsp.window.fullscreen()")

              (modBind "CTRL + SHIFT + S" ''hl.dsp.exec_cmd("${pkgs.hyprshot}/bin/hyprshot -m region")'')
              (bind "CTRL + SHIFT + S" ''hl.dsp.exec_cmd("${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only")'')

              (bind "XF86AudioRaiseVolume" ''hl.dsp.exec_cmd("wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+")'')
              (bind "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-")'')
              (bind "XF86AudioMute" ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'')

              (bind "XF86AudioPlay" ''hl.dsp.exec_cmd("${pkgs.playerctl}/bin/playerctl play-pause")'')
              (bind "XF86AudioPause" ''hl.dsp.exec_cmd("${pkgs.playerctl}/bin/playerctl play-pause")'')
              (bind "XF86AudioNext" ''hl.dsp.exec_cmd("${pkgs.playerctl}/bin/playerctl next")'')
              (bind "XF86AudioPrev" ''hl.dsp.exec_cmd("${pkgs.playerctl}/bin/playerctl previous")'')

              (modBindMouse "mouse:272" "hl.dsp.window.drag()")
              (modBindMouse "mouse:273" "hl.dsp.window.resize()")
            ];
          };
        };
      }
    )
  ];
}
