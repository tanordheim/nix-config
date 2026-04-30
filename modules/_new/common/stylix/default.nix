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
    image = ../../../../wallpapers/themed/catppuccin/mocha/catppuccin-mocha-kurzgesagt-galaxy3.png;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

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
        package = pkgs.aporetic-bin;
        name = "Aporetic Sans Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 13;
        popups = 13;
      };
    };

    opacity.terminal = 0.95;
  };

  home-manager.sharedModules = [
    {
      gtk.gtk4.theme = null;
    }
  ];
}
