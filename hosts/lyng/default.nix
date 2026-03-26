{ inputs, ... }:
inputs.nix-darwin.lib.darwinSystem {
  specialArgs = inputs;
  modules = [
    {
      nixpkgs.hostPlatform = "aarch64-darwin";
    }
    (
      { config, ... }:
      {
        system.stateVersion = 5;
        home-manager.users.${config.username} = {
          home.stateVersion = "24.11";
        };
      }
    )
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.stylix.darwinModules.stylix
    ../../modules/macos
  ]
  ++ (builtins.attrValues inputs.nix-config-private.outputs.homeManagerModules)
  ++ (builtins.attrValues inputs.nix-config-private.outputs.nixModules);
}
