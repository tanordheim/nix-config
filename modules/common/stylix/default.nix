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
    polarity = "dark";
    base16Scheme = {
      scheme = "Kanagawa Dragon";
      author = "rebelot (https://github.com/rebelot/kanagawa.nvim), base16 by LennyLizowzskiy";
      base00 = "181616";
      base01 = "0d0c0c";
      base02 = "2d4f67";
      base03 = "a6a69c";
      base04 = "7fb4ca";
      base05 = "c5c9c5";
      base06 = "938aa9";
      base07 = "c5c9c5";
      base08 = "c4746e";
      base09 = "e46876";
      base0A = "c4b28a";
      base0B = "8a9a7b";
      base0C = "8ea4a2";
      base0D = "8ba4b0";
      base0E = "a292a3";
      base0F = "7aa89f";
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
