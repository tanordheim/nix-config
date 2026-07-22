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
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

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
