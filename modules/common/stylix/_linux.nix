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
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
  };
}
