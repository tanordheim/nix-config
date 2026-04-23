{
  flake.modules.homeManager.stern =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.stern.enable {
        home.packages = [ pkgs.stern ];
      };
    };
}
