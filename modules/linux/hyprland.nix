{
  pkgs,
  config,
  ...
}:
let
  keypadNumberToKeyCode = {
    "0" = "code:90";
    "1" = "code:87";
    "2" = "code:88";
    "3" = "code:89";
    "4" = "code:83";
    "5" = "code:84";
    "6" = "code:85";
    "7" = "code:79";
    "8" = "code:80";
    "9" = "code:81";
  };
in
{
  environment.systemPackages = with pkgs; [
    hyprland-qtutils
    wl-clipboard
  ];

  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  home-manager.users.${config.username} = {
    xdg.portal = {
      enable = true;
      configPackages = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];
      xdgOpenUsePortal = true;
    };
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mainMod" = "SUPER";
        "$altMod" = "CTRL";

        env = [
          "QT_QPA_PLATFORMTHEME,qt5ct"
          "GSK_RENDERER,gl" # required for some GTK apps, see https://gitlab.gnome.org/GNOME/gtk/-/issues/7010
        ];

        general = {
          gaps_in = 5;
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
          "$mainMod, ${keypadNumberToKeyCode."1"}, workspace, 1"
          "$mainMod, ${keypadNumberToKeyCode."2"}, workspace, 2"
          "$mainMod, ${keypadNumberToKeyCode."3"}, workspace, 3"
          "$mainMod, ${keypadNumberToKeyCode."4"}, workspace, 4"
          "$mainMod, ${keypadNumberToKeyCode."5"}, workspace, 5"
          "$mainMod, ${keypadNumberToKeyCode."6"}, workspace, 6"
          "$mainMod, ${keypadNumberToKeyCode."7"}, workspace, 7"
          "$mainMod, ${keypadNumberToKeyCode."8"}, workspace, 8"
          "$mainMod, ${keypadNumberToKeyCode."9"}, workspace, 9"
          "$mainMod, ${keypadNumberToKeyCode."0"}, workspace, 10"

          # move window to workspace
          "$mainMod $altMod, ${keypadNumberToKeyCode."1"}, movetoworkspace, 1"
          "$mainMod $altMod, ${keypadNumberToKeyCode."2"}, movetoworkspace, 2"
          "$mainMod $altMod, ${keypadNumberToKeyCode."3"}, movetoworkspace, 3"
          "$mainMod $altMod, ${keypadNumberToKeyCode."4"}, movetoworkspace, 4"
          "$mainMod $altMod, ${keypadNumberToKeyCode."5"}, movetoworkspace, 5"
          "$mainMod $altMod, ${keypadNumberToKeyCode."6"}, movetoworkspace, 6"
          "$mainMod $altMod, ${keypadNumberToKeyCode."7"}, movetoworkspace, 7"
          "$mainMod $altMod, ${keypadNumberToKeyCode."8"}, movetoworkspace, 8"
          "$mainMod $altMod, ${keypadNumberToKeyCode."9"}, movetoworkspace, 9"
          "$mainMod $altMod, ${keypadNumberToKeyCode."0"}, movetoworkspace, 10"

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

          # media keys
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"
          ", mouse_left, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"
          ", mouse_right, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"
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

          # make sure the polkit agent window is front and center
          "pin, title:^(Hyprland Polkit Agent)$"
          "stayfocused, title:^(Hyprland Polkit Agent)$"

          # assign apps to certain workspaces
          "workspace 6 silent, class:^(chrome-app.slack.com__)(.*)$"
          "workspace 7 silent, class:^(org.telegram.desktop)$"
          "workspace 7 silent, class:^(Signal)$"
          "workspace 8 silent, class:^(chrome-discord.com__)(.*)$"
          "workspace 9 silent, class:^(chrome-linear.app__)(.*)$"
          "workspace 10 silent, class:^(1Password)$, floating:0"
          "pin, class:^(1Password)$, title:^(1Password)$, floating:1"
        ];

        exec-once = [
          # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          # "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "${pkgs.waybar}/bin/waybar &"
          "${pkgs._1password-gui}/bin/1password &"
          "blueman-applet &"
          "${pkgs.networkmanagerapplet}/bin/nm-applet &"
          "hyprctl dispatch workspace 1"
          "${pkgs.weylus}/bin/weylus --no-gui --try-vaapi --wayland-support"
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
    programs.zsh.initContent = # zsh
      ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          dbus-run-session Hyprland
        fi
      '';
  };
}
