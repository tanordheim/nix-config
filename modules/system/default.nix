{ isDarwin, ... }:
{
  imports = [
    ./homebrew
    ./nix

    ./fonts.nix
    ./home-manager.nix
    ./nixpkgs.nix
    ./users.nix
  ];
}
