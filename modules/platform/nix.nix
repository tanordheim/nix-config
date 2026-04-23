{ inputs, ... }:
let
  baseNixConfig =
    { lib, ... }:
    {
      nix = {
        settings = {
          trusted-users = [ "root" ];
          experimental-features = "nix-command flakes";
        };
        gc = {
          automatic = true;
          options = "--delete-older-than 30d";
        };
        optimise.automatic = true;
      };

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
      ++ (import ../../overlays inputs);
    };
in
{
  flake.modules.darwin.base = baseNixConfig;
  flake.modules.nixos.base = baseNixConfig;
}
