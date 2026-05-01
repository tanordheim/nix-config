{ pkgs, ... }:
{
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  home-manager.sharedModules = [
    {
      home.packages = [
        pkgs.lutris
        pkgs.instawow
      ];
    }
  ];
}
