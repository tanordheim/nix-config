{
  pkgs,
  lib,
  config,
  ...
}:
let
  scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  wallpaper = ../../wallpapers/themed/catppuccin/mocha/catppuccin-mocha-kurzgesagt-galaxy3.png;
in
{
  stylix = {
    enable = true;
    image = wallpaper;
    polarity = "dark";
    base16Scheme = scheme;

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        popups = 13;
        terminal = lib.mkDefault 11;
      };
    };

    opacity = {
      terminal = 0.95;
    };
  };
}
