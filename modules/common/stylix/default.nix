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
      scheme = "Kanagawa";
      author = "rebelot (https://github.com/rebelot/kanagawa.nvim), base16 by montdor";
      base00 = "1F1F28";
      base01 = "2A2A37";
      base02 = "223249";
      base03 = "727169";
      base04 = "C8C093";
      base05 = "DCD7BA";
      base06 = "938AA9";
      base07 = "363646";
      base08 = "C34043";
      base09 = "FFA066";
      base0A = "DCA561";
      base0B = "98BB6C";
      base0C = "7FB4CA";
      base0D = "7E9CD8";
      base0E = "957FB8";
      base0F = "D27E99";
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
