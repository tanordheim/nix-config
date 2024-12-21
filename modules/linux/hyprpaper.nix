{ pkgs, config, ... }:
let
  wallpaperPath = config.wallpaper;

in
{
  home-manager.users.${config.username} =
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
