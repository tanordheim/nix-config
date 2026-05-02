{ lib, isDarwin, pkgs, ... }:
{
  imports = [ (lib.mkPlatformImport ./. isDarwin) ];

  users.users.trond = {
    name = "trond";
    description = "Trond Nordheim";
    shell = pkgs.zsh;
  };
}
