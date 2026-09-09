{ config, ... }:
{
  virtualisation.oci-containers = {
    backend = "podman";
    containers.npps4 = {
      image = "ghcr.io/darkenergyprocessor/npps4@sha256:dd123ba5b8dcb9a420a972b5702a1fb14dedd773dcb00037a320ceec2792c7c9";
      pull = "missing";
      networks = [ "host" ];
      extraOptions = [
        "--image-volume=ignore"
        "--security-opt=no-new-privileges"
        "--cap-drop=ALL"
      ];
      volumes = [ "/var/lib/npps4:/NPPS4/data" ];
      environment = {
        NPPS4_CONFIG_DATABASE_URL = "sqlite+aiosqlite:////NPPS4/data/main.sqlite3";
        NPPS4_CONFIG_DOWNLOAD_BACKEND = "n4dlapi";
        NPPS4_CONFIG_DOWNLOAD_N4DLAPI_SERVER = "https://ll.sif.moe/npps4_dlapi";
        NPPS4_CONFIG_MAIN_SERVERDATA = "data/server_data.json";
        NPPS4_WORKER = "1";
      };
      environmentFiles = [ config.sops.templates."npps4-env".path ];
    };
  };

  systemd.tmpfiles.rules = [ "d /var/lib/npps4 0750 root root -" ];

  sops.templates."npps4-env" = {
    content = ''
      NPPS4_CONFIG_MAIN_SECRETKEY=${config.sops.placeholder."npps4/secret_key"}
    '';
    restartUnits = [ "podman-npps4.service" ];
  };
}
