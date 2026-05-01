{ pkgs, ... }:
{
  programs.hyprland.enable = true;
  programs.dconf.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
      user = "greeter";
    };
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        colors = config.lib.stylix.colors or null;
      in
      {
        home.packages = with pkgs; [
          brightnessctl
          hyprland-qtutils
          hyprpolkitagent
          libnotify
          pavucontrol
          playerctl
          wl-clipboard
          xdg-utils
        ];

        xdg.portal = {
          enable = true;
          configPackages = with pkgs; [ xdg-desktop-portal-hyprland ];
          xdgOpenUsePortal = true;
        };

        services.hypridle = {
          enable = true;
          settings = {
            general = {
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "hyprctl dispatch dpms on";
              ignore_dbus_inhibit = false;
            };
            listener = [
              {
                timeout = 300;
                on-timeout = "loginctl lock-session";
              }
              {
                timeout = 600;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }
            ];
          };
        };

        services.hyprpaper.enable = true;

        programs.hyprlock = {
          enable = true;
          settings = {
            general.hide_cursor = true;
            background = {
              blur_passes = 3;
              blur_size = 8;
            };
            input-field = {
              size = "300, 60";
              outline_thickness = "4";
              dots_size = "0.2";
              dots_spacing = "0.2";
              dots_center = "true";
              fade_on_empty = false;
              placeholder_text = "$USER";
              hide_input = false;
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
              position = "0, -47";
              halign = "center";
              valign = "center";
            };
          };
        };

        programs.hyprpanel = {
          enable = true;
          settings = {
            bar.layouts = {
              "0" = {
                left = [
                  "dashboard"
                  "workspaces"
                  "netstat"
                ];
                middle = [ "windowtitle" ];
                right = [
                  "systray"
                  "volume"
                  "network"
                  "cpu"
                  "ram"
                  "clock"
                  "notifications"
                ];
              };
            };
            theme.bar.floating = true;
            theme.bar.border_radius = "0.4em";
            theme.bar.transparent = true;
            theme.bar.buttons.enableBorders = true;
            bar.clock.format = "%b %d %Y %H:%M";
            notifications.active_monitor = true;
            menus.clock.time.military = true;
          };
        };

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
              dim_inactive = true;
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

            misc = {
              force_default_wallpaper = 0;
              disable_hyprland_logo = true;
              animate_manual_resizes = true;
              mouse_move_enables_dpms = true;
              key_press_enables_dpms = true;
              middle_click_paste = false;
            };

            bind = [
              "$mainMod, return, exec, ${pkgs.kitty}/bin/kitty --directory=$HOME"
              "$mainMod SHIFT, W, killactive"
              "$mainMod CTRL, Q, exit"
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

              "$mainMod, print,       exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
              "$mainMod SHIFT, print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"

              ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"
              ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"
              ", XF86AudioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

              "$mainMod CTRL, L, exec, hyprlock"
            ];

            bindm = [
              "$mainMod, mouse:272, movewindow"
              "$mainMod, mouse:273, resizewindow"
            ];

            exec-once = [
              "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
              "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
              "systemctl --user start hyprpolkitagent"
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

            cursor.no_hardware_cursors = true;

            monitor = [
              ", preferred, auto, 1"
            ];
          };
        };
      }
    )
  ];
}
