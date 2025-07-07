{
  pkgs,
  config,
  ...
}:
{
  home-manager.users.${config.username}.services.hypridle = {
    enable = true;

    settings = {
      general = {
        # lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple instances
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
}
