{
  pkgs,
  lib,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    hyprland-qtutils
    wl-clipboard
  ];

  programs.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  home-manager.users.${config.username} = {
    xdg.portal = {
      enable = true;
      configPackages = with pkgs; [
        xdg-desktop-portal-hyprland
        #   xdg-desktop-portal-gtk
        #   xdg-desktop-portal
      ];
      # extraPortals = with pkgs; [
      # xdg-desktop-portal-hyprland
      # xdg-desktop-portal-gtk
      #   xdg-desktop-portal
      # ];
      xdgOpenUsePortal = true;
    };
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mainMod" = "ALT";
        "$altMod" = "CTRL";

        env = [
          "QT_QPA_PLATFORMTHEME,qt5ct"
          "GSK_RENDERER,gl" # required for some GTK apps, see https://gitlab.gnome.org/GNOME/gtk/-/issues/7010
        ];

        general = {
          gaps_in = 10;
          gaps_out = 15;
          border_size = 2;
          layout = "master";
          allow_tearing = false;

          # more snassy border than the default one in Stylix
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

        master = {
          new_status = "slave";
        };

        gestures = {
          workspace_swipe = false;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          animate_manual_resizes = true;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
          middle_click_paste = false;
        };

        bind = [
          # launchers
          "$mainMod, return, exec, ${pkgs.wezterm}/bin/wezterm"
          "$mainMod SHIFT, W, killactive"
          "$mainMod $altMod, Q, exit"
          "$mainMod, space, exec, sherlock"
          "$mainMod, e, exec, ${pkgs.nautilus}/bin/nautilus"

          # switch workspaces
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

          # move window to workspace
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

          # move focused window
          "$mainMod, left, movefocus, l"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod, right, movefocus, r"

          # scratch/special workspace
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          # screenshots
          "SUPER, S, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
          "SUPER SHIFT, S, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"

          # media keys
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"
          ", mouse_left, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"
          ", mouse_right, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"
        ];

        bindm = [
          # move/resize using $mainMod + mouse drag
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindl = [
          # enable/disable built in screen when lid opens/closes
          ", switch:off:Apple SMC power/lid events, exec, hyprctl keyword monitor 'eDP-1,preferred,4880x0,1'"
          ", switch:on:Apple SMC power/lid events, exec, hyprctl keyword monitor 'eDP-1,disable'"
        ];

        windowrulev2 = [
          # stop blurring menus
          "noblur, title:^()$, class:^()$"

          # add color to xwayland window borders
          "bordercolor $red, xwayland: 1"

          # make sure the polkit agent window is front and center
          "pin, title:^(Hyprland Polkit Agent)$"
          "stayfocused, title:^(Hyprland Polkit Agent)$"

          # assign apps to certain workspaces
          "workspace 6 silent, class:^(chrome-app.slack.com__)(.*)$"
          "workspace 6 silent, class:^(org.telegram.desktop)$"
          "workspace 7 silent, class:^(Signal)$"
          "workspace 7 silent, class:^(chrome-discord.com__)(.*)$"
          "workspace 8 silent, class:^(chrome-linear.app__)(.*)$"
          "workspace 10 silent, class:^(1Password)$, floating:0"
          "pin, class:^(1Password)$, title:^(1Password)$, floating:1"

          # fix dragging tabs/splits in jetbrains tools
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
          touchpad = {
            natural_scroll = false;
          };
        };

        monitor = [
          "DVI-I-1, 2560x1440@60, 0x0, 1" # , transform, 1"
          "HDMI-A-1, 3440x1440@100, 2560x350, 1"
          # "HDMI-A-1, 3440x1440@100, 1440x350, 1"
          # "eDP-1, 2456x2160@60, 4880x-10, 1"
          "eDP-1, 2456x2160@60, 6000x-10, 1"
          # "DVI-I-1,2560x1440,0x0,1,transform,1"
          # "HDMI-A-1,3440x1440@100.00Hz,1480x350,1"
          # "eDP-1,3456x2160,4920x0,1"
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
}
