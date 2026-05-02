{ inputs, lib, pkgs, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix.fonts.sizes.terminal = lib.mkDefault 11;

  stylix.cursor = {
    size = 24;
    package = pkgs.catppuccin-cursors.mochaDark;
    name = "Catppuccin-Mocha-Dark-Cursors";
  };
}
