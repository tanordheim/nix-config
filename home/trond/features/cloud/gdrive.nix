{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gdrive3
  ];
}
