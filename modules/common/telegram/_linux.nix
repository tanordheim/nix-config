{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.telegram-desktop ];
      }
    )
  ];
}
