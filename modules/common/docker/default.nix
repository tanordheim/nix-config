{
  pkgs,
  lib,
  isDarwin,
  ...
}:
{
  imports = [ (lib.mkPlatformImport ./. isDarwin) ];

  environment.systemPackages = [ pkgs.docker-compose ];
}
