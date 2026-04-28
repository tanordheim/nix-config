{
  flake.modules.homeManager.syncthing =
    {
      lib,
      config,
      ...
    }:
    {
      config = lib.mkIf config.host.features.syncthing.enable {
        services.syncthing.enable = true;
      };
    };
}
