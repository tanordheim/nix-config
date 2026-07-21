{
  pkgs,
  lib,
  isDarwin,
  ...
}:
{
  imports = [
    (lib.mkPlatformImport ./. isDarwin)
  ];

  stylix = {
    enable = true;
    image = ../../../wallpapers/themed/catppuccin/mocha/catppuccin-mocha-saturn.png;
    polarity = "light";
    base16Scheme = {
      scheme = "Everforest Light (Medium)";
      author = "Márcio Sobel (https://github.com/marciosobel)";
      base00 = "fdf6e3";
      base01 = "f4f0d9";
      base02 = "e6e2cc";
      base03 = "939f91";
      base04 = "829181";
      base05 = "5c6a72";
      base06 = "475258";
      base07 = "2d353b";
      base08 = "f85552";
      base09 = "f57d26";
      base0A = "dfa000";
      base0B = "8da101";
      base0C = "35a77c";
      base0D = "3a94c5";
      base0E = "df69ba";
      base0F = "829181";
    };

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Sans";
      };
      monospace = {
        package = pkgs.aporetic-bin;
        name = "Aporetic Sans Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 11;
        popups = 11;
      };
    };

    opacity.terminal = 0.95;
  };

  home-manager.sharedModules = [
    {
      stylix.enableReleaseChecks = false;
    }
  ];
}
