{ ... }:
{
  imports = [
    # temporarily disabled as roslyn-ls is broken: https://github.com/NixOS/nixpkgs/pull/439459
    # ./csharp.nix
    ./go.nix
    ./html.nix
    ./javascript.nix
    ./lua.nix
    ./kotlin.nix
    ./nix.nix
    ./proto.nix
    ./python.nix
    ./rust.nix
    ./terraform.nix
    ./toml.nix
    ./yaml.nix
  ];
}
