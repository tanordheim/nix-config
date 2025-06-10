{
  hyprpanel,
  config,
  ...
}:
{
  home-manager.users.${config.username} =
    { config, ... }:
    let
      colors = config.lib.stylix.colors;
    in
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

          theme.font.name = "${config.stylix.fonts.sansSerif.name}";
          theme.font.size = "${builtins.toString config.stylix.fonts.sizes.desktop}pt";
          # theme.bar.scaling = 85;
          theme.bar.floating = true;
          theme.bar.buttons.enableBorders = true;
          theme.bar.buttons.borderSize = "0.1em";
        };
      };
    };
}
