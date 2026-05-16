{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        services.hyprpaper = {
          enable = true;
          package = pkgs.bleeding.hyprpaper;
        };
      }
    )
  ];
}
