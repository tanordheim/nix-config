{ pkgs, config, ... }:
let
  scheme = ./stylix-themes/kanagawa.yaml;
  wallpaper = ../../wallpapers/generic/scenery/generic-scenery-24.png;
in
{
  stylix = {
    enable = true;
    image = wallpaper;
    polarity = "dark";
    base16Scheme = scheme;

    cursor = {
      size = 24;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };

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
        name = "JetBrainsMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        popups = 13;
        terminal = 13;
      };
    };

    opacity = {
      terminal = 0.95;
    };
  };
}
