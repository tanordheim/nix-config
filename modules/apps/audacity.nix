{
  flake.modules.homeManager.audacity =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.audacity.enable {
        home.packages = [ pkgs.audacity ];
      };
    };
}
