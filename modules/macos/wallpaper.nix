{ pkgs, config, ... }:
let
  wallpaperPath = config.wallpaper;

in
{
  home-manager.users.${config.username} =
    { lib, config, ... }:
    {
      home.activation = {
        setDarwinWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          /usr/bin/osascript -e 'tell application "System Events" to tell every desktop to set picture to "${config.lib.file.mkOutOfStoreSymlink wallpaperPath}" as POSIX file'
        '';
      };
    };
}
