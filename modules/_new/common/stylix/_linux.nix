{ inputs, lib, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix.fonts.sizes.terminal = lib.mkDefault 11;
}
