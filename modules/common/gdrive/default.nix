{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.gdrive3 ];
      }
    )
  ];
}
