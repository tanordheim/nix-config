{
  flake.modules.darwin.raycast =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.raycast.enable {
        environment.systemPackages = [ pkgs.raycast ];
      };
    };
}
