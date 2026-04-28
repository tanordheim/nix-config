{
  flake.modules.darwin.gaming =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.gaming.enable {
        homebrew.casks = [ "battle-net" ];
      };
    };
}
