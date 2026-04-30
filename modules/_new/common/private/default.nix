{ inputs, ... }:
{
  home-manager.sharedModules = [
    inputs.nix-config-private.homeManagerModules.default
  ];
}
