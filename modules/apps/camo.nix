{
  flake.modules.darwin.camo =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.camo.enable {
        homebrew.casks = [ "camo-studio" ];
      };
    };
}
