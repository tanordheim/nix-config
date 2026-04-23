{
  flake.modules.homeManager.brave =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.brave.enable {
        home.packages = [ pkgs.brave ];

        xdg.desktopEntries.brave-browser = {
          exec = "brave --ozone-platform=wayland --js-flags=--no-decommit-pooled-pages --new-window %u";
          icon = "brave";
          name = "Brave";
          terminal = false;
          type = "Application";
        };
      };
    };
}
