{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.aporetic-bin
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.symbols-only
  ];
}
