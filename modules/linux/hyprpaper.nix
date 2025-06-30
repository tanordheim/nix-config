{
  pkgs,
  config,
  hyprpaper,
  ...
}:
{
  home-manager.users.${config.username}.services.hyprpaper = {
    enable = true;
    package = hyprpaper.packages.${pkgs.system}.default;
  };
}
