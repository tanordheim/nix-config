{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.teams-for-linux ];
      }
    )
  ];
}
