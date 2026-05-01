{
  lib,
  isDarwin,
  ...
}:
{
  imports = [ (lib.mkPlatformImport ./. isDarwin) ];
}
