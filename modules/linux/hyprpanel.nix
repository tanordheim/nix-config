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
        systemd.enable = true;
        hyprland.enable = true;
      };
    };
}
