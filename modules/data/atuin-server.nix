{
  flake.modules.nixos.atuin-server =
    {
      lib,
      config,
      ...
    }:
    {
      config = lib.mkIf config.host.features.atuin-server.enable {
        services.atuin = {
          enable = true;
          openRegistration = true;
          host = "127.0.0.1";
          port = 8888;
        };

        services.caddy.virtualHosts."atuin.home.nordheim.io".extraConfig = ''
          reverse_proxy localhost:8888
        '';
      };
    };
}
