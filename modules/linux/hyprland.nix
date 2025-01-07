{
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  # programs.hyprland.enable = true;
  # programs.hyprland.package = with pkgs; stable.hyprland;

  home-manager.users.${config.username} = {
    # xdg.portal = {
    #   enable = true;
    #   config = {
    #     common = {
    #       default = [ "hyprland" ];
    #     };
    #     hyprland = {
    #       default = [ "hyprland" ];
    #     };
    #   };
    #   extraPortals = with pkgs; [
    #     stable.xdg-desktop-portal-hyprland
    #   ];
    #   xdgOpenUsePortal = true;
    # };
    wayland.windowManager.hyprland = {
      enable = true;
      package = with pkgs; stable.hyprland;
      #   settings = {
      #     "$mainMod" = "SUPER";
      #     "$altMod" = "CTRL";
      #     "$mehMod" = "CTRL SHIFT ALT";
      #     "$hypMod" = "SUPER CTRL SHIFT ALT";
      #
      #     env = [
      #       "QT_QPA_PLATFORMTHEME,qt5ct"
      #     ];
      #
      #     general = {
      #       gaps_in = 5;
      #       gaps_out = 15;
      #       border_size = 2;
      #       layout = "master";
      #       allow_tearing = false;
      #     };
      #
      #     decoration = {
      #       active_opacity = 1;
      #       fullscreen_opacity = 1;
      #       inactive_opacity = 1;
      #       dim_inactive = true;
      #       dim_strength = 0.2;
      #
      #       blur = {
      #         enabled = true;
      #         size = 8;
      #         passes = 1;
      #         new_optimizations = true;
      #       };
      #
      #       shadow = {
      #         enabled = true;
      #         range = 6;
      #         render_power = 3;
      #         ignore_window = true;
      #       };
      #     };
      #
      #     animations = {
      #       enabled = true;
      #       animation = [
      #         "windows, 1, 2, default, popin"
      #         "windowsOut, 1, 2, default, popin"
      #         "border, 1, 10, default"
      #         "fade, 1, 5, default"
      #         "workspaces, 1, 2, default"
      #       ];
      #     };
      #
      #     dwindle = {
      #       pseudotile = true;
      #       preserve_split = true;
      #     };
      #
      #     master = {
      #       new_status = "slave";
      #     };
      #
      #     gestures = {
      #       workspace_swipe = false;
      #     };
      #
      #     misc = {
      #       force_default_wallpaper = 0;
      #       disable_hyprland_logo = true;
      #       animate_manual_resizes = true;
      #       mouse_move_enables_dpms = true;
      #       key_press_enables_dpms = true;
      #     };
      #
      #     bind = [
      #       # launchers
      #       "$mainMod, return, exec, ${pkgs.kitty}/bin/kitty"
      #       "$mainMod SHIFT, W, killactive"
      #       "$mainMod $altMod, Q, exit"
      #       "$mainMod, space, exec, rofi -show drun"
      #       "$mainMod, c, exec, rofi -show calc -modi calc -no-show-match -no-sort -calc-command \"echo -n '{result}' | wl-copy\""
      #       "$mainMod, e, exec, ${pkgs.nautilus}/bin/nautilus"
      #
      #       # switch workspaces
      #       "$mehMod, a, workspace, 1"
      #       "$mehMod, r, workspace, 2"
      #       "$mehMod, s, workspace, 3"
      #       "$mehMod, t, workspace, 4"
      #       "$mehMod, g, workspace, 5"
      #       "$mehMod, m, workspace, 6"
      #       "$mehMod, n, workspace, 7"
      #       "$mehMod, e, workspace, 8"
      #       "$mehMod, i, workspace, 9"
      #       "$mehMod, o, workspace, 10"
      #
      #       # move window to workspace
      #       "$hypMod, left, movetoworkspace, -1"
      #       "$hypMod, right, movetoworkspace, +1"
      #       "$hypMod, a, movetoworkspace, 1"
      #       "$hypMod, r, movetoworkspace, 2"
      #       "$hypMod, s, movetoworkspace, 3"
      #       "$hypMod, t, movetoworkspace, 4"
      #       "$hypMod, g, movetoworkspace, 5"
      #       "$hypMod, m, movetoworkspace, 6"
      #       "$hypMod, n, movetoworkspace, 7"
      #       "$hypMod, e, movetoworkspace, 8"
      #       "$hypMod, i, movetoworkspace, 9"
      #       "$hypMod, o, movetoworkspace, 10"
      #
      #       # move focused window
      #       "$mainMod, left, movefocus, l"
      #       "$mainMod, up, movefocus, u"
      #       "$mainMod, down, movefocus, d"
      #       "$mainMod, right, movefocus, r"
      #
      #       # scratch/special workspace
      #       "$mainMod, S, togglespecialworkspace, magic"
      #       "$mainMod SHIFT, S, movetoworkspace, special:magic"
      #
      #       # screenshots
      #       "$mainMod SHIFT, 4, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
      #       "$mainMod $altMod SHIFT, 4, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"
      #
      #       # media keys
      #       ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"
      #       ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"
      #     ];
      #
      #     bindm = [
      #       # move/resize using $mainMod + mouse drag
      #       "$mainMod, mouse:272, movewindow"
      #       "$mainMod, mouse:273, resizewindow"
      #     ];
      #
      #     windowrulev2 = [
      #       # stop blurring menus
      #       "noblur, title:^()$, class:^()$"
      #
      #       # add color to xwayland window borders
      #       "bordercolor $red, xwayland: 1"
      #
      #       # assign apps to certain workspaces
      #       "workspace 6 silent, class:^(chrome-app.slack.com__)(.*)$"
      #       "workspace 7 silent, class:^(org.telegram.desktop)$"
      #       "workspace 7 silent, class:^(Signal)$"
      #       "workspace 8 silent, class:^(chrome-discord.com__)(.*)$"
      #       "workspace 9 silent, class:^(chrome-linear.app__)(.*)$"
      #       "workspace 10 silent, class:^(1Password)$, floating:0"
      #       "pin, class:^(1Password)$, title:^(1Password)$, floating:1"
      #     ];
      #
      #     exec-once = [
      #       "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      #       "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      #       "${pkgs.waybar}/bin/waybar &"
      #       "${pkgs._1password-gui}/bin/1password &"
      #       "blueman-applet &"
      #       "${pkgs.networkmanagerapplet}/bin/nm-applet &"
      #       "hyprctl dispatch workspace 1"
      #     ];
      #
      #     input = {
      #       kb_layout = "us";
      #       float_switch_override_focus = false;
      #       numlock_by_default = true;
      #       repeat_rate = 50;
      #       repeat_delay = 250;
      #
      #       follow_mouse = false;
      #       sensitivity = 0;
      #       touchpad = {
      #         natural_scroll = false;
      #       };
      #     };
      #
      #     monitor = [
      #       "HDMI-A-1,3840x1600,0x0,1"
      #       "eDP-1,3456x2160,3840x192,2"
      #       ",preferred,auto,1"
      #     ];
      #
      #     workspace = [
      #       "1, monitor:HDMI-A-1"
      #       "2, monitor:HDMI-A-1"
      #       "3, monitor:HDMI-A-1"
      #       "4, monitor:HDMI-A-1"
      #       "5, monitor:HDMI-A-1"
      #       "6, monitor:eDP-1"
      #       "7, monitor:eDP-1"
      #       "8, monitor:eDP-1"
      #       "9, monitor:eDP-1"
      #       "10, monitor:eDP-1"
      #     ];
      #   };
    };
  };
}
