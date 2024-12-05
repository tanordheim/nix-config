{ pkgs, config, ... }:
let
  wallpaperPath = config.d.desktop.wallpaper;

in
{
  environment.systemPackages = with pkgs; [
    m-cli
  ];

  my.user = { lib, config, ... }: {
    home.activation = {
      setDarwinWallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
        # need to temporarily set path for osascript to be callable by m-cli
        PATH="/usr/bin:$PATH" ${pkgs.m-cli}/bin/m wallpaper "${config.lib.file.mkOutOfStoreSymlink wallpaperPath}"
      '';
    };
  };
}
