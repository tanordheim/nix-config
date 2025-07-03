{
  pkgs,
  config,
  ...
}:
{
  home-manager.users.${config.username} = {
    home.packages = with pkgs; [
      hyprpolkitagent
    ];
    wayland.windowManager.hyprland.settings.exec-once = [
      "systemctl --user start hyprpolkitagent"
    ];
  };
}
