{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
