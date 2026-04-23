{
  flake.modules.darwin.teams =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.teams.enable {
        homebrew.casks = [ "microsoft-teams" ];
      };
    };
}
