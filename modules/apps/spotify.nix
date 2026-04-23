{
  flake.modules.darwin.spotify =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.spotify.enable {
        homebrew.casks = [ "spotify" ];
      };
    };
}
