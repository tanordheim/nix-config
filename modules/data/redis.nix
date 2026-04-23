{
  flake.modules.homeManager.redis =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.redis.enable {
        home.packages = [ pkgs.redis ];
      };
    };

  flake.modules.darwin.redis = { lib, ... }: { };
  flake.modules.nixos.redis = { lib, ... }: { };
}
