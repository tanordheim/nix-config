{
  flake.modules.nixos.seerr =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.seerr.enable {
        services.seerr.enable = true;
        systemd.services.seerr.serviceConfig.Restart = lib.mkForce "always";

        services.caddy.virtualHosts."seerr.home.nordheim.io".extraConfig = ''
          reverse_proxy localhost:5055
        '';
      };
    };
}
