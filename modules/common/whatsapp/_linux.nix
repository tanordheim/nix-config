{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.whatsapp-electron ];
      }
    )
  ];
}
