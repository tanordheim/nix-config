{ inputs, pkgs, ... }:
let
  outputs = inputs.self;
in
{
  imports = [
    ./nix.nix
    ./fonts.nix
    ./stylix.nix
    ./timezone.nix
    ./sudo.nix
  ];

  environment.systemPackages = with pkgs; [
    coreutils
    curl
    diffutils
    file
    findutils
    gawk
    gnugrep
    gnused
    gnutar
    gzip
    jq
    killall
    lsof
    tree
    unzip
    zip
  ];

  programs.zsh.enable = true;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs; };
}
