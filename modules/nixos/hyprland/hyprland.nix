{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        wayland.windowManager.hyprland = {
          enable = true;
          settings = {
            "$mainMod" = "ALT";
            "$focusMod" = "SUPER";
            "$moveMod" = "CTRL SUPER";

            env = [
              "QT_QPA_PLATFORMTHEME,qt5ct"
              "GSK_RENDERER,gl"
            ];

            general = {
              gaps_in = 10;
              gaps_out = 15;
              border_size = 2;
              layout = "master";
              allow_tearing = false;
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
              };
            };

            animations = {
              enabled = true;
              animation = [
                "windows, 1, 2, default, popin"
                "windowsOut, 1, 2, default, popin"
                "border, 1, 10, default"
                "fade, 1, 5, default"
                "workspaces, 1, 2, default"
              ];
            };

            dwindle = {
              pseudotile = true;
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
            };

            bind = [
              "$mainMod, return, exec, ${pkgs.kitty}/bin/kitty --directory=$HOME"
              "$mainMod, space, exec, ${pkgs.hyprlauncher}/bin/hyprlauncher"
              "$mainMod SHIFT, W, killactive"
              "$mainMod CTRL SUPER, BackSpace, exit"
              "$mainMod CTRL, C, exec, hyprctl reload"

              "$focusMod, h, movefocus, l"
              "$focusMod, j, movefocus, d"
              "$focusMod, k, movefocus, u"
              "$focusMod, l, movefocus, r"

              "$moveMod, h, movewindow, l"
              "$moveMod, j, movewindow, d"
              "$moveMod, k, movewindow, u"
              "$moveMod, l, movewindow, r"

              "$mainMod SHIFT, 1, workspace, 1"
              "$mainMod SHIFT, 2, workspace, 2"
              "$mainMod SHIFT, 3, workspace, 3"
              "$mainMod SHIFT, 4, workspace, 4"
              "$mainMod SHIFT, 5, workspace, 5"
              "$mainMod SHIFT, 6, workspace, 6"
              "$mainMod SHIFT, 7, workspace, 7"
              "$mainMod SHIFT, 8, workspace, 8"
              "$mainMod SHIFT, 9, workspace, 9"
              "$mainMod SHIFT, 0, workspace, 10"

              "$mainMod SHIFT, KP_End,      workspace, 1"
              "$mainMod SHIFT, KP_Down,     workspace, 2"
              "$mainMod SHIFT, KP_Next,     workspace, 3"
              "$mainMod SHIFT, KP_Left,     workspace, 4"
              "$mainMod SHIFT, KP_Begin,    workspace, 5"
              "$mainMod SHIFT, KP_Right,    workspace, 6"
              "$mainMod SHIFT, KP_Home,     workspace, 7"
              "$mainMod SHIFT, KP_Up,       workspace, 8"
              "$mainMod SHIFT, KP_Prior,    workspace, 9"
              "$mainMod SHIFT, KP_Insert,   workspace, 10"

              "$mainMod CTRL, 1, movetoworkspace, 1"
              "$mainMod CTRL, 2, movetoworkspace, 2"
              "$mainMod CTRL, 3, movetoworkspace, 3"
              "$mainMod CTRL, 4, movetoworkspace, 4"
              "$mainMod CTRL, 5, movetoworkspace, 5"
              "$mainMod CTRL, 6, movetoworkspace, 6"
              "$mainMod CTRL, 7, movetoworkspace, 7"
              "$mainMod CTRL, 8, movetoworkspace, 8"
              "$mainMod CTRL, 9, movetoworkspace, 9"
              "$mainMod CTRL, 0, movetoworkspace, 10"

              "$mainMod CTRL, KP_End,    movetoworkspace, 1"
              "$mainMod CTRL, KP_Down,   movetoworkspace, 2"
              "$mainMod CTRL, KP_Next,   movetoworkspace, 3"
              "$mainMod CTRL, KP_Left,   movetoworkspace, 4"
              "$mainMod CTRL, KP_Begin,  movetoworkspace, 5"
              "$mainMod CTRL, KP_Right,  movetoworkspace, 6"
              "$mainMod CTRL, KP_Home,   movetoworkspace, 7"
              "$mainMod CTRL, KP_Up,     movetoworkspace, 8"
              "$mainMod CTRL, KP_Prior,  movetoworkspace, 9"
              "$mainMod CTRL, KP_Insert, movetoworkspace, 10"

              "$mainMod, page_down, workspace, e-1"
              "$mainMod, page_up,   workspace, e+1"
              "$mainMod, home,      workspace, previous"

              "$mainMod SHIFT, S, togglespecialworkspace, magic"
              "$mainMod CTRL,  S, movetoworkspace, special:magic"

              "CTRL SHIFT ALT, F, togglefloating"
              "CTRL SHIFT ALT, T, togglesplit"

              "CTRL SHIFT ALT, S, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
              "CTRL SHIFT, S,     exec, ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"

              ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"
              ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"
              ", XF86AudioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

              ", XF86AudioPlay,  exec, ${pkgs.playerctl}/bin/playerctl play-pause"
              ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
              ", XF86AudioNext,  exec, ${pkgs.playerctl}/bin/playerctl next"
              ", XF86AudioPrev,  exec, ${pkgs.playerctl}/bin/playerctl previous"

              "$mainMod CTRL, L, exec, hyprlock"
            ];

            bindm = [
              "$mainMod, mouse:272, movewindow"
              "$mainMod, mouse:273, resizewindow"
            ];

            input = {
              kb_layout = "no";
              kb_variant = "nodeadkeys";
              float_switch_override_focus = false;
              numlock_by_default = true;
              repeat_rate = 50;
              repeat_delay = 250;
              follow_mouse = false;
              sensitivity = 0;
            };

            monitor = [
              "DP-1, 2560x1440@155, 0x0, 1, transform, 1"
              "DP-2, 3440x1440@180, 1440x320, 1"
            ];

            workspace = [
              "1, monitor:DP-2, default:true"
              "2, monitor:DP-2"
              "3, monitor:DP-2"
              "4, monitor:DP-2"
              "5, monitor:DP-2"
              "6, monitor:DP-1, default:true, layoutopt:orientation:top"
              "7, monitor:DP-1, layoutopt:orientation:top"
              "8, monitor:DP-1, layoutopt:orientation:top"
              "9, monitor:DP-1, layoutopt:orientation:top"
              "10, monitor:DP-1, layoutopt:orientation:top"
            ];

            windowrule = [
              "workspace 6 silent, match:class ^(Slack)$"
              "workspace 6 silent, match:class ^(org\\.telegram\\.desktop)$"
              "workspace special:magic silent, match:title ^(TradeSkillMaster Application.*)$"
              "workspace special:hidden silent, match:class ^(explorer\\.exe)$, match:title ^$"
            ];
          };
        };
      }
    )
  ];
}
