{
  flake.modules.darwin.whatsapp =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.whatsapp.enable {
        homebrew.casks = [ "whatsapp" ];
      };
    };
}
