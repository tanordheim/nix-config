{ inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (prev: final: {
      bleeding = import inputs.nixpkgs-unstable-small {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
  ]
  ++ (import ../../overlays inputs);
}
