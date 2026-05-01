{ pkgs, ... }:
{
  programs.steam.enable = true;

  home-manager.sharedModules = [
    {
      home.packages = [ pkgs.lutris ];
    }
  ];
}
