{ inputs, ... }:
inputs.nix-darwin.lib.darwinSystem {
  specialArgs = inputs;
  modules = [
    {
      nixpkgs.hostPlatform = "aarch64-darwin";
    }
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.stylix.darwinModules.stylix
    ../../modules/macos
  ]
  ++ (builtins.attrValues inputs.nix-config-private.outputs.homeManagerModules)
  ++ (builtins.attrValues inputs.nix-config-private.outputs.nixModules);
}
