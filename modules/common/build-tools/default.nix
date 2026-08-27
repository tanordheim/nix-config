{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          age
          checkmake
          cloc
          cmake
          dos2unix
          ffmpeg
          gcc
          gnumake
          gnupatch
          grpcurl
          just
          shellcheck
          shfmt
          sops
          unixtools.watch
        ];
      }
    )
  ];
}
