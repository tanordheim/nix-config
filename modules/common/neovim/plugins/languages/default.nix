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
    ./terraform.nix
    ./yaml.nix
  ];
}
