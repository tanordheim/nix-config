{
  flake.modules.homeManager.hyprland =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      colors = config.lib.stylix.colors or null;
      facePath = ../../media/face.png;
    in
    {
      config = lib.mkIf config.host.features.hyprland.enable {
        home.packages = with pkgs; [
          hyprland-qtutils
          hyprpolkitagent
          libnotify
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
            label = [
              {
                text = "$TIME";
                color = colors.withHashtag.base05;
                font_size = config.stylix.fonts.sizes.applications * 7;
                font_family = config.stylix.fonts.sansSerif.name;
                position = "-30, 0";
                halign = "right";
                valign = "top";
              }
              {
                text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
                color = colors.withHashtag.base05;
                font_size = config.stylix.fonts.sizes.applications * 2;
                font_family = config.stylix.fonts.sansSerif.name;
                position = "-30, -150";
                halign = "right";
                valign = "top";
              }
            ];
            image = {
              path = "${config.lib.file.mkOutOfStoreSymlink facePath}";
              size = "100";
              border_color = colors.withHashtag.base0E;
              position = "0, 75";
              halign = "center";
              valign = "center";
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
              capslock_color = colors.withHashtag.base0A;
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
                left = [ ];
                middle = [ ];
                right = [ ];
              };
              "1" = {
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
                  "battery"
                  "clock"
                  "notifications"
                ];
              };
              "2" = {
                left = [ ];
                middle = [ ];
                right = [ ];
              };
            };
            theme.name = "catppuccin_mocha";
            theme.font.name = "${config.stylix.fonts.monospace.name}";
            theme.font.size = "${builtins.toString config.stylix.fonts.sizes.desktop}pt";
            theme.bar.floating = true;
            theme.bar.border_radius = "0.4em";
            theme.bar.transparent = true;
            theme.bar.buttons.enableBorders = true;
            theme.bar.buttons.borderSize = "0.1em";
            theme.bar.buttons.radius = "0.3em";
            theme.bar.buttons.workspaces.enableBorder = false;
            bar.clock.format = "%b %d %Y %H:%M";
            notifications.active_monitor = true;
            menus.clock.time.military = true;
          };
        };

        wayland.windowManager.hyprland = {
          enable = true;
          settings = {
            "$mainMod" = "ALT";
            "$altMod" = "CTRL";

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
              "col.active_border" = lib.mkForce "rgb(8aadf4) rgb(24273A) rgb(24273A) rgb(8aadf4) 45deg";
              "col.inactive_border" = lib.mkForce "rgb(24273A) rgb(24273A) rgb(24273A) rgb(27273A) 45deg";
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
            gestures.workspace_swipe = false;

            misc = {
              force_default_wallpaper = 0;
              disable_hyprland_logo = true;
              animate_manual_resizes = true;
              mouse_move_enables_dpms = true;
              key_press_enables_dpms = true;
              middle_click_paste = false;
            };

            bind = [
              "$mainMod, return, exec, ${pkgs.wezterm}/bin/wezterm"
              "$mainMod SHIFT, W, killactive"
              "$mainMod $altMod, Q, exit"
              "$mainMod, space, exec, sherlock"
              "$mainMod, e, exec, ${pkgs.nautilus}/bin/nautilus"

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

              "$mainMod, left, movefocus, l"
              "$mainMod, up, movefocus, u"
              "$mainMod, down, movefocus, d"
              "$mainMod, right, movefocus, r"

              "$mainMod, S, togglespecialworkspace, magic"
              "$mainMod SHIFT, S, movetoworkspace, special:magic"

              "SUPER, S, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
              "SUPER SHIFT, S, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"

              ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"
              ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"
              ", mouse_left, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"
              ", mouse_right, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"

              "$mainMod $altMod, L, exec, hyprlock"
            ];

            bindm = [
              "$mainMod, mouse:272, movewindow"
              "$mainMod, mouse:273, resizewindow"
            ];

            bindl = [
              ", switch:off:Apple SMC power/lid events, exec, hyprctl keyword monitor 'eDP-1,preferred,4880x0,1'"
              ", switch:on:Apple SMC power/lid events, exec, hyprctl keyword monitor 'eDP-1,disable'"
            ];

            windowrulev2 = [
              "noblur, title:^()$, class:^()$"
              "bordercolor $red, xwayland: 1"
              "pin, title:^(Hyprland Polkit Agent)$"
              "stayfocused, title:^(Hyprland Polkit Agent)$"
              "workspace 6 silent, class:^(chrome-app.slack.com__)(.*)$"
              "workspace 6 silent, class:^(org.telegram.desktop)$"
              "workspace 7 silent, class:^(Signal)$"
              "workspace 7 silent, class:^(chrome-discord.com__)(.*)$"
              "workspace 8 silent, class:^(chrome-linear.app__)(.*)$"
              "workspace 10 silent, class:^(1Password)$, floating:0"
              "pin, class:^(1Password)$, title:^(1Password)$, floating:1"
              "float, class:^(jetbrains-.*),title:^(win.*)"
              "noinitialfocus, opacity 0.9 0.9, class:^(jetbrains-.*)"
            ];

            exec-once = [
              "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
              "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
              "${pkgs._1password-gui}/bin/1password &"
              "blueman-applet &"
              "${pkgs.networkmanagerapplet}/bin/nm-applet &"
              "hyprctl dispatch workspace 1"
              "${pkgs.weylus}/bin/weylus --no-gui --try-vaapi --wayland-support"
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
              touchpad.natural_scroll = false;
            };

            cursor.no_hardware_cursors = true;

            monitor = [
              "DVI-I-1, 2560x1440@60, 0x0, 1, transform, 1"
              "DVI-I-1, addreserved, 0, 0, 0, 0"
              "HDMI-A-1, 3440x1440@100, 1440x350, 1"
              "eDP-1, 2456x2160@60, 4880x-10, 1"
              ", preferred, auto, 1"
            ];

            workspace = [
              "1, monitor:HDMI-A-1"
              "2, monitor:HDMI-A-1"
              "3, monitor:HDMI-A-1"
              "4, monitor:HDMI-A-1"
              "5, monitor:HDMI-A-1"
              "6, monitor:DVI-I-1, layoutopt:orientation:top"
              "7, monitor:DVI-I-1, layoutopt:orientation:top"
              "8, monitor:DVI-I-1, layoutopt:orientation:top"
              "9, monitor:DVI-I-1, layoutopt:orientation:top"
              "10, monitor:eDP-1"
            ];
          };
        };
      };
    };
}
