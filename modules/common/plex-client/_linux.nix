{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.plex-desktop
          pkgs.plexamp
        ];
      }
    )
  ];
}
