{
  flake.modules.homeManager.postgres =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.postgres.enable {
        home.packages = [ pkgs.pgcli ];
        xdg.configFile."pgcli/config".text = ''
          [main]
          keyring = False
        '';
      };
    };

  flake.modules.darwin.postgres = { lib, ... }: { };
  flake.modules.nixos.postgres = { lib, ... }: { };
}
