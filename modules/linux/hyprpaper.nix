{
  pkgs,
  config,
  ...
}:
{
  home-manager.users.${config.username}.services.hyprpaper = {
    enable = true;
  };
}
