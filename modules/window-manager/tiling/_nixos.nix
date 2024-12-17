{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  my.user = {
    gtk.catppuccin = {
      enable = true;
      icon.enable = true;
    };
    qt.style.catppuccin.enable = true;
  };

  programs.hyprland.enable = true;

  my.user.dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  my.user.wayland.windowManager.hyprland = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      "$mainMod" = "SUPER";
      "$altMod" = "CTRL";
      "$mehMod" = "CTRL SHIFT ALT";
      "$hypMod" = "SUPER CTRL SHIFT ALT";

      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 15;
        border_size = 2;
        layout = "master";
        allow_tearing = false;

        "col.active_border" = "$mauve";
        "col.inactive_border" = "$peach";
      };

      decoration = {
        active_opacity = 1;
        fullscreen_opacity = 1;
        inactive_opacity = 1;
        dim_inactive = true;
        dim_strength = 0.2;

        blur = {
          enabled = true;
          size = 8;
          passes = 1;
          new_optimizations = true;
        };

        shadow = {
          enabled = true;
          range = 6;
          render_power = 3;
          ignore_window = true;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin, 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
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
      };

      bind = [
        # launchers
        "$mainMod, return, exec, ${pkgs.alacritty}/bin/alacritty"
        "$mainMod SHIFT, W, killactive"
        "$mainMod $altMod, Q, exit"
        "$mainMod, space, exec, ${pkgs.rofi-wayland}/bin/rofi -show drun"

        # switch workspaces
        "$mainMod, a, workspace, 1"
        "$mainMod, r, workspace, 2"
        "$mainMod, s, workspace, 3"
        "$mainMod, t, workspace, 4"
        "$mainMod, g, workspace, 5"
        "$mainMod, m, workspace, 6"
        "$mainMod, n, workspace, 7"
        "$mainMod, e, workspace, 8"
        "$mainMod, i, workspace, 9"
        "$mainMod, o, workspace, 10"

        # move window to workspace
        "$mehMod, left, movetoworkspace, -1"
        "$mehMod, right, movetoworkspace, +1"
        "$mehMod, a, movetoworkspace, 1"
        "$mehMod, r, movetoworkspace, 2"
        "$mehMod, s, movetoworkspace, 3"
        "$mehMod, t, movetoworkspace, 4"
        "$mehMod, g, movetoworkspace, 5"
        "$mehMod, m, movetoworkspace, 6"
        "$mehMod, n, movetoworkspace, 7"
        "$mehMod, e, movetoworkspace, 8"
        "$mehMod, i, movetoworkspace, 9"
        "$mehMod, o, movetoworkspace, 10"

        # move focused window
        "$mainMod, left, movefocus, l"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, right, movefocus, r"

        # scratch/special workspace
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # screenshots
        "$mainMod SHIFT, 4, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
        "$mainMod $altMod SHIFT, 4, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"
      ];

      bindm = [
        # move/resize using $mainMod + mouse drag
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        # stop blurring menus
        "noblur, title:^()$, class:^()$"

        # add color to xwayland window borders
        "bordercolor $red, xwayland: 1"
      ];

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.waybar}/bin/waybar > /home/trond/waybar.log 2>&1"
        "blueman-applet &"
        "${pkgs.networkmanagerapplet}/bin/nm-applet &"
        "hyprctl dispatch workspace 1"
      ];

      input = {
        kb_layout = "us";
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
        "HDMI-A-1,3840x1600,0x0,1"
        "eDP-1,3456x2160,3840x192,2"
        ",preferred,auto,1"
      ];

      workspace = [
        "1, monitor:HDMI-A-1"
        "2, monitor:HDMI-A-1"
        "3, monitor:HDMI-A-1"
        "4, monitor:HDMI-A-1"
        "5, monitor:HDMI-A-1"
        "6, monitor:eDP-1"
        "7, monitor:eDP-1"
        "8, monitor:eDP-1"
        "9, monitor:eDP-1"
        "10, monitor:eDP-1"
      ];
    };
  };
}
