{
  nixpkgs,
  nixpkgs-stable,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (prev: final: {
      stable = import nixpkgs-stable { inherit (prev) system; };
    })
  ];
}
