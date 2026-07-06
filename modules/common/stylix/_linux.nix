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
    # WORKAROUND: unstable catppuccin-cursors pulls an uncached inkscape-1.4.4
    # (build-time SVG renderer) that compiles from source on every bump; stable
    # is cached. Drop the `stable.` prefix once unstable's build lands in cache.
    package = pkgs.stable.catppuccin-cursors.mochaDark;
    name = "Catppuccin-Mocha-Dark-Cursors";
  };
}
