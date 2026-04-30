{ inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (prev: final: {
      stable = import inputs.nixpkgs-stable {
        system = prev.stdenv.hostPlatform.system;
      };
      bleeding = import inputs.nixpkgs-unstable-small {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
      custom = import inputs.nixpkgs-custom {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
  ]
  ++ (import ../../../overlays inputs);
}
