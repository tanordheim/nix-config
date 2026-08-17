{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix.fonts.sizes.terminal = lib.mkDefault 11;

  stylix.targets.kmscon.enable = false;

  stylix.cursor = {
    size = 24;
    # WORKAROUND: unstable catppuccin-cursors pulls uncached Inkscape into the build closure.
    package = pkgs.stable.catppuccin-cursors.mochaMauve;
    name = "catppuccin-mocha-mauve-cursors";
  };
}
