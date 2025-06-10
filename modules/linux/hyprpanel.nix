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
                left = [ ];
                middle = [ ];
                right = [ ];
              };

              # portrait monitor
              "1" = {
                left = [
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
              "2" = {
                left = [ "workspaces" ];
                middle = [ ];
                right = [ "windowtitle" ];
              };
            };
          };

          theme.font.size = "1rem";
          theme.bar.scaling = 85;
          theme.bar.floating = true;
        };
      };
    };
}
