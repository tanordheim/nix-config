{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        services.hyprpaper = {
          enable = true;
          package = pkgs.hyprpaper;
          systemdTarget = "wayland-session@hyprland.desktop.target";
        };
      }
    )
  ];
}
