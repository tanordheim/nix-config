{
  nixpkgs,
  nixpkgs-stable,
  nixpkgs-unstable-small,
  nixpkgs-custom,
  ...
}@args:
{
  nix = {
    settings = {
      trusted-users = [
        "root"
      ];
      experimental-features = "nix-command flakes";
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
  nixpkgs.overlays = [
    (prev: final: {
      stable = import nixpkgs-stable { system = prev.stdenv.hostPlatform.system; };
      bleeding = import nixpkgs-unstable-small {
        system = prev.stdenv.hostPlatform.system;
        config = {
          allowUnfree = true;
        };
      };
      custom = import nixpkgs-custom {
        system = prev.stdenv.hostPlatform.system;
        config = {
          allowUnfree = true;
        };
      };
    })
  ]
  ++ (import ../../../overlays args);
}
