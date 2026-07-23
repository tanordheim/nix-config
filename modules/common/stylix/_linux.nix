{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  # WORKAROUND: stylix sets home.pointerCursor.* without .enable, tripping
  # home-manager's deprecation of implicit enablement. Drop once stylix gates
  # it upstream. https://github.com/danth/stylix/issues/2407
  home-manager.sharedModules = [
    { home.pointerCursor.enable = true; }
  ];

  stylix.fonts.sizes.terminal = lib.mkDefault 11;

  stylix.targets.kmscon.enable = false;

  stylix.cursor = {
    size = 24;
    # WORKAROUND: unstable catppuccin-cursors pulls an uncached inkscape-1.4.4
    # (build-time SVG renderer) that compiles from source on every bump; stable
    # is cached. Drop the `stable.` prefix once unstable's build lands in cache.
    package = pkgs.stable.catppuccin-cursors.mochaMauve;
    name = "catppuccin-mocha-mauve-cursors";
  };
}
