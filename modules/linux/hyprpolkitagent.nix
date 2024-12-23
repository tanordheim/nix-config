{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    hyprpolkitagent
  ];

  home-manager.users.${config.username}.wayland.windowManager.hyprland.settings.exec-once = [
    "systemctl --user start hyprpolkitagent"
  ];
}
