{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.aporetic-bin
    pkgs.codicon-extras
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.symbols-only
  ];
}
