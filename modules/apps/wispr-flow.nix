{
  flake.modules.darwin.wispr-flow =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.wispr-flow.enable {
        homebrew.casks = [ "wispr-flow" ];
      };
    };
}
