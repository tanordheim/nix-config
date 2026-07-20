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
      scheme = "Dawnfox";
      author = "EdenEast (https://github.com/EdenEast/nightfox.nvim)";
      base00 = "faf4ed";
      base01 = "ebe5df";
      base02 = "d0d8d8";
      base03 = "9893a5";
      base04 = "625c87";
      base05 = "575279";
      base06 = "504c6b";
      base07 = "4c4769";
      base08 = "b4637a";
      base09 = "d7827e";
      base0A = "ea9d34";
      base0B = "618774";
      base0C = "56949f";
      base0D = "286983";
      base0E = "907aa9";
      base0F = "d685af";
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
