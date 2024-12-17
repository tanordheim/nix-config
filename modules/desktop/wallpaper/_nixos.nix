{ pkgs, config, ... }:
let
  wallpaperPath = config.d.desktop.wallpaper;

in
{
  my.user =
    { lib, config, ... }:
    {
      services.hyprpaper = {
        enable = true;
        settings = {
          preload = [
            "${config.lib.file.mkOutOfStoreSymlink wallpaperPath}"
          ];
          wallpaper = [ ", ${config.lib.file.mkOutOfStoreSymlink wallpaperPath}" ];
        };
      };
    };
}
