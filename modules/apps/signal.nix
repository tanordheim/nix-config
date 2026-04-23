{
  flake.modules.darwin.signal =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.signal.enable {
        homebrew.casks = [ "signal" ];
      };
    };
}
