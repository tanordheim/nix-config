{
  pkgs,
  config,
  hyprpolkitagent,
  ...
}:
{
  home-manager.users.${config.username} = {
    home.packages = [
      hyprpolkitagent.packages.${pkgs.system}.default
    ];
    wayland.windowManager.hyprland.settings.exec-once = [
      "systemctl --user start hyprpolkitagent"
    ];
  };
}
