{
  flake.modules.darwin.chrome =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.chrome.enable {
        homebrew.casks = [ "google-chrome" ];
      };
    };
}
