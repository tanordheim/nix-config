{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.signal-desktop ];
      }
    )
  ];
}
