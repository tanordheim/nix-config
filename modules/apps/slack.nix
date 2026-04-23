{
  flake.modules.darwin.slack =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.slack.enable {
        homebrew.casks = [ "slack" ];
      };
    };
}
