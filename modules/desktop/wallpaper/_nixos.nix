{ pkgs, config, ... }:
let
  wallpaperPath = config.d.desktop.wallpaper;

in
{
  environment.systemPackages = with pkgs; [
    hyprpaper
  ];
  my.user =
    { lib, config, ... }:
    {
      xdg.configFile = {
        "hypr/hyprpaper.conf" = {
          text = ''
            preload = ${config.lib.file.mkOutOfStoreSymlink wallpaperPath}
            wallpaper = , ${config.lib.file.mkOutOfStoreSymlink wallpaperPath}
          '';
        };
      };
    };
}
