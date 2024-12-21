{ pkgs, config, ... }:
let
  scheme = ./stylix-themes/${config.theming.nightfoxStyle}.yaml;
  wallpaper = ../../wallpapers/themed/nightfox/${config.theming.nightfoxStyle}.png;
in
{
  stylix = {
    enable = true;
    # image = ../../wallpapers/themed/catppuccin/mocha/catppuccin-mocha-kurzgesagt-cloudy-quasar1.png;
    image = wallpaper;
    polarity = "dark";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
    # base16Scheme = ./stylix-themes/nightfox.yaml;
    base16Scheme = scheme;

    cursor = {
      size = 28;
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "Catppuccin-Mocha-Dark-Cursors";
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
