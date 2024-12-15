{
  nixpkgs,
  nixpkgs-stable,
  nixpkgs-brave-stable,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (prev: final: {
      stable = import nixpkgs-stable { inherit (prev) system; };
      brave = import nixpkgs-brave-stable { inherit (prev) system; };
    })
  ];
}
