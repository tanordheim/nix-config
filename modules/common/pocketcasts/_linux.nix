{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.pocket-casts ];
      }
    )
  ];
}
