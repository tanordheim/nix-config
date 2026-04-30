{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.pgcli ];
        xdg.configFile."pgcli/config".text = ''
          [main]
          keyring = False
        '';
      }
    )
  ];
}
