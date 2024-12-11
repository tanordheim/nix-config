{ pkgs, config, ... }:
let
  wallpaperPath = config.d.desktop.wallpaper;

in
{
  my.user =
    { lib, config, ... }:
    {
      home.activation = {
        setDarwinWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          /usr/bin/osascript -e 'tell application "System Events" to tell every desktop to set picture to "${config.lib.file.mkOutOfStoreSymlink wallpaperPath}" as POSIX file'
        '';
      };
    };
}
