{
  nixpkgs,
  nixpkgs-stable,
  config,
  ...
}:
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

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (prev: final: {
      stable = import nixpkgs-stable { inherit (prev) system; };
    })
  ];
}
