{
  hyprpanel,
  config,
  ...
}:
{
  home-manager.users.${config.username} =
    { config, ... }:
    {
      imports = [
        hyprpanel.homeManagerModules.hyprpanel
      ];
      programs.hyprpanel = {
        enable = true;
        hyprland.enable = true;

        settings = {
          layout = {
            "bar.layouts" = {
              # internal monitor
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
                  "kbinput"
                  "battery"
                  "clock"
                  "notifications"
                ];
              };

              # portrait monitor
              "1" = {
                left = [ "workspaces" ];
                middle = [ ];
                right = [ "windowtitle" ];
              };

              # main monitor
              "2" = {
                left = [ ];
                middle = [ ];
                right = [ ];
              };
            };
          };
        };
      };
    };
}
