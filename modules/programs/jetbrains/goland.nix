{ pkgs, ... }:
{
  my.user.home.packages = [
    pkgs.jetbrains.goland
  ];
}
