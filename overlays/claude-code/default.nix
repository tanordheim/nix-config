{ nixpkgs-claude-code-pr, ... }:
final: prev: {
  # WORKAROUND: claude-code 2.1.257 (Fable 5.1) not yet in nixpkgs-unstable-small,
  # https://github.com/NixOS/nixpkgs/pull/558900
  bleeding = prev.bleeding // {
    claude-code = prev.bleeding.callPackage "${nixpkgs-claude-code-pr}/pkgs/by-name/cl/claude-code/package.nix" { };
  };
}
