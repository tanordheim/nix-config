{ pkgs, ... }:
{
  my.user.home.packages = [
    pkgs.jetbrains.rider
  ];
}
