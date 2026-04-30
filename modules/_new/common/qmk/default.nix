{
  pkgs,
  lib,
  isDarwin,
  ...
}:
{
  imports = [ (lib.mkPlatformImport ./. isDarwin) ];

  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.qmk ];
      }
    )
  ];
}
