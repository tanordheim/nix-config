{ inputs, ... }:
inputs.nix-darwin.lib.darwinSystem {
  system = "x86_64-darwin";
  specialArgs = inputs;
  modules = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.stylix.darwinModules.stylix
    ../../modules/macos
  ]
  ++ (builtins.attrValues inputs.nix-config-private.outputs.homeManagerModules)
  ++ (builtins.attrValues inputs.nix-config-private.outputs.nixModules);
}
