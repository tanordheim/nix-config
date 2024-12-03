{ pkgs, ... }:
{
  imports = [
    ./desktop
    ./programs
    ./security
    ./system
    ./window-manager

    ./aws.nix
    ./config.nix
    ./shells.nix
  ];

  environment.systemPackages = with pkgs; [
    cmake
    coreutils
    curl
    diffutils
    file
    findutils
    gawk
    gcc
    gnugrep
    gnumake
    gnupatch
    gnused
    gnutar
    gzip
    jq
    killall
    lsof
    unzip
    zip
  ];
}
