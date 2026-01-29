{ nixpkgs-swift, ... }:
# see https://github.com/NixOS/nixpkgs/issues/483584
final: prev:
let
  pkgs-swift = import nixpkgs-swift {
    system = prev.stdenv.hostPlatform.system;
  };
in
{
  swift = pkgs-swift.swift;
  swiftPackages = pkgs-swift.swiftPackages;
}
