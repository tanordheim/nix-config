{
  nixpkgs,
  nixpkgs-stable,
  nixpkgs-unstable-small,
  nixpkgs-custom,
  inputs,
  config,
  ...
}@args:
{
  nix = {
    settings = {
      trusted-users = [
        "root"
        config.username
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
    permittedInsecurePackages = [
      # TODO: https://github.com/NixOS/nixpkgs/issues/326335
      "dotnet-sdk-6.0.428"
    ];
  };
  nixpkgs.overlays = [
    (prev: final: {
      stable = import nixpkgs-stable { inherit (prev) system; };
      bleeding = import nixpkgs-unstable-small { inherit (prev) system; };
      custom = import nixpkgs-custom {
        inherit (prev) system;
        config = {
          allowUnfree = true;
        };
      };
    })
  ]
  ++ (import ../../overlays args);
}
