{ pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      home.packages = [ pkgs.androidStudioPackages.beta ];
    }
  ];
}
