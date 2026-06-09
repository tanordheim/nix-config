{ pkgs, ... }:
{
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("com.feralinteractive.GameMode.") == 0
          && subject.isInGroup("gamemode")) {
        return polkit.Result.YES;
      }
    });
  '';

  home-manager.sharedModules = [
    {
      home.packages = [
        pkgs.lutris
        pkgs.wowup-cf
        pkgs.tsm-app
      ];

      xdg.configFile."autostart/tsm-app.desktop".source =
        "${pkgs.tsm-app}/share/applications/tsm-app.desktop";
    }
  ];
}
