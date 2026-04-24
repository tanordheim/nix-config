{
  flake.modules.homeManager.base =
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
        sops
        unixtools.watch
      ];
    };
}
