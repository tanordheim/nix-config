{
  flake.modules.darwin.pocketcasts =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.pocketcasts.enable {
        homebrew.casks = [ "pocket-casts" ];
      };
    };
}
