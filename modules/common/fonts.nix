{ pkgs, ... }:
{
  # # TODO: make user fonts maybe?
  # environment.systemPackages = with pkgs; [
  #   nerd-fonts.jetbrains-mono
  #   nerd-fonts.symbols-only
  # ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.iosevka-term
    pkgs.nerd-fonts.symbols-only
  ];
}
