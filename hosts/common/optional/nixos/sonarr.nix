{ config, lib, ... }:
{
  services.sonarr.enable = true;
  systemd.services.sonarr.serviceConfig.Restart = lib.mkForce "always";

  services.sonarr.environmentFiles = [
    config.sops.templates."sonarr-env".path
  ];

  sops.templates."sonarr-env" = {
    restartUnits = [ "sonarr.service" ];
    content = ''
      SONARR__AUTH__APIKEY=${config.sops.placeholder."sonarr/api_key"}
      SONARR__AUTH__METHOD=External
      SONARR__AUTH__REQUIRED=DisabledForLocalAddresses
      SONARR__MAIN__BACKUPFOLDER=/data/backups/hsrv/sonarr
    '';
  };

  services.caddy.virtualHosts."sonarr.home.nordheim.io".extraConfig = ''
    reverse_proxy localhost:8989
  '';
}
