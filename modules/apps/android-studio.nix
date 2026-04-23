{
  flake.modules.darwin.android-studio =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.android-studio.enable {
        homebrew.casks = [ "android-studio" ];
      };
    };
}
