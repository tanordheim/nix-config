{
  hyprpanel,
  config,
  ...
}:
{
  services.power-profiles-daemon.enable = true; # Required for hyprpanel battery module
  services.upower.enable = true; # Required for hyprpanel battery module

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
                  "cpu"
                  "ram"
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
          bar.customModules.netstat.icon = "󰣺";
          bar.customModules.netstat.round = true;
          notifications.active_monitor = true;
          menus.clock.time.military = true;
        };
      };
    };
}
