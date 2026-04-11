{ config, lib, ... }:
{
  services.radarr.enable = true;
  systemd.services.radarr.serviceConfig.Restart = lib.mkForce "always";

  services.radarr.environmentFiles = [
    config.sops.templates."radarr-env".path
  ];

  sops.templates."radarr-env" = {
    restartUnits = [ "radarr.service" ];
    content = ''
      RADARR__AUTH__APIKEY=${config.sops.placeholder."radarr/api_key"}
      RADARR__AUTH__METHOD=External
      RADARR__AUTH__REQUIRED=DisabledForLocalAddresses
      RADARR__MAIN__BACKUPFOLDER=/data/backups/hsrv/radarr
    '';
  };

  services.caddy.virtualHosts."radarr.home.nordheim.io".extraConfig = ''
    reverse_proxy localhost:7878
  '';
}
