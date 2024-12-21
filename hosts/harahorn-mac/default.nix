{ inputs, ... }:
inputs.nix-darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = inputs;
  modules =
    [
      home-manager.darwinModules.home-manager
      nix-homebrew.darwinModules.nix-homebrew
      ../../modules/macos
    ]
    ++ (builtins.attrValues nix-config-private.outputs.homeManagerModules)
    ++ (builtins.attrValues nix-config-private.outputs.nixModules);
}
