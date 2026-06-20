{ pkgs, ... }:
{
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  fonts.packages = [
    pkgs.corefonts
    pkgs.vista-fonts
  ];

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
        pkgs.protontricks
        pkgs.lutris
      ];
    }
  ];
}
