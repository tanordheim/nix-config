{ nixpkgs-swift, ... }:
# see https://github.com/NixOS/nixpkgs/issues/483584
final: prev: {
  swift = nixpkgs-swift.swift;
}
