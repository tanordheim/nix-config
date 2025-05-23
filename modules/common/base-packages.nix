{ pkgs, ... }:
{
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
    grpcurl
    gzip
    jq
    killall
    lsof
    nvd
    unixtools.watch
    unzip
    tree
    zip
  ];
}
