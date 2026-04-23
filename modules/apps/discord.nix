{
  flake.modules.darwin.discord =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.discord.enable {
        environment.systemPackages = [ pkgs.discord ];
      };
    };
}
