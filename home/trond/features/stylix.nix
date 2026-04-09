{
  pkgs,
  lib,
  config,
  ...
}:
{
  gtk.gtk4.theme = null;

  launchd.agents.stylixwallpaper = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      Label = "set-stylix-wallpaper";
      ProgramArguments = [
        "/usr/local/bin/desktoppr"
        (toString config.stylix.image)
      ];
      RunAtLoad = true;
      StandardOutPath = "/tmp/set-stylix-wallpaper.log";
      StandardErrorPath = "/tmp/set-stylix-wallpaper.error.log";
    };
  };
}
