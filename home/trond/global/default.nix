{ inputs, ... }:
{
  imports = [
    ../features/cli
    ../features/stylix.nix
    inputs.nix-config-private.homeManagerModules.default
  ];

  programs.home-manager.enable = true;
}
