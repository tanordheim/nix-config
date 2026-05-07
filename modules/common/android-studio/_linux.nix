{ pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      home.packages = [ pkgs.android-studio ];
    }
  ];
}
