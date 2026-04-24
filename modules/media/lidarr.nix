{
  flake.modules.nixos.lidarr =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.lidarr.enable {
        services.lidarr.enable = true;
        systemd.services.lidarr.serviceConfig.Restart = lib.mkForce "always";

        services.lidarr.environmentFiles = [
          config.sops.templates."lidarr-env".path
        ];

        sops.templates."lidarr-env" = {
          restartUnits = [ "lidarr.service" ];
          content = ''
            LIDARR__AUTH__APIKEY=${config.sops.placeholder."lidarr/api_key"}
            LIDARR__AUTH__METHOD=External
            LIDARR__AUTH__REQUIRED=DisabledForLocalAddresses
            LIDARR__MAIN__BACKUPFOLDER=/data/backups/hsrv/lidarr
          '';
        };

        services.caddy.virtualHosts."lidarr.home.nordheim.io".extraConfig = ''
          reverse_proxy localhost:8686
        '';
      };
    };
}
