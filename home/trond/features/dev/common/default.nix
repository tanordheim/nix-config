{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cloc
    cmake
    dos2unix
    ffmpeg
    gcc
    gnumake
    gnupatch
    grpcurl
    unixtools.watch
  ];
}
