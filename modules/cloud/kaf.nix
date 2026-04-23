{
  flake.modules.homeManager.kaf =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.kaf.enable {
        home.packages = [ pkgs.kaf ];
      };
    };
}
