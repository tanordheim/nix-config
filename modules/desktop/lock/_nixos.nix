{ pkgs, config, ... }:
let
  wallpaperPath = config.d.desktop.wallpaper;
  facePath = config.d.user.image;
  fontFamily = "JetBrainsMono Nerd Font";

in
{
  my.user =
    { lib, config, ... }:
    {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple instances
            before_sleep_cmd = "loginctl lock-session"; # lock before suspend
            after_sleep_cmd = "hyprctl dispatch dpms on"; # avoid having to press a key twice to turn on the display
            ignore_dbus_inhibit = false; # listen to dbus inhibits (firefox etc)
          };

          listener = [
            # lock session after 5 minutes
            {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            }

            # screen off after 10 minutes
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

      programs.hyprlock = {
        enable = true;
        catppuccin.enable = true;
        settings = {
          general = {
            disable_loading_bar = true;
            hide_cursor = true;
          };

          background = {
            path = "${config.lib.file.mkOutOfStoreSymlink wallpaperPath}";
            blur_passes = 3;
            blur_size = 8;
            color = "$base";
          };

          label = [
            {
              text = "$TIME";
              color = "$text";
              font_size = "90";
              font_family = "${fontFamily}";
              position = "-30, 0";
              halign = "right";
              valign = "top";
            }
            {
              text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
              color = "$text";
              font_size = "25";
              font_family = "${fontFamily}";
              position = "-30, -150";
              halign = "right";
              valign = "top";
            }
          ];

          image = {
            path = "${config.lib.file.mkOutOfStoreSymlink facePath}";
            size = "100";
            border_color = "$accent";
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
            outer_color = "$accent";
            inner_color = "$surface0";
            font_color = "$text";
            fade_on_empty = false;
            placeholder_text = "<span foreground=\"##$textAlpha\"><i>󰌾 Logged in as </i><span foreground=\"##$accentAlpha\">$USER</span></span>";
            hide_input = false;
            check_color = "$accent";
            fail_color = "$red";
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            capslock_color = "$yellow";
            position = "0, -47";
            halign = "center";
            valign = "center";
          };
        };
      };
    };
}
