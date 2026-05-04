{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          age
          cloc
          cmake
          dos2unix
          ffmpeg
          gcc
          gnumake
          gnupatch
          grpcurl
          just
          sops
          unixtools.watch
        ];
      }
    )
  ];
}
