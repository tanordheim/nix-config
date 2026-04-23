{
  flake.modules.darwin.logitech =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.logitech.enable {
        homebrew.casks = [ "logi-options+" ];
      };
    };
}
