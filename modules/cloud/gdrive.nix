{
  flake.modules.homeManager.gdrive =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.gdrive.enable {
        home.packages = [ pkgs.gdrive3 ];
      };
    };
}
