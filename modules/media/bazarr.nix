{
  flake.modules.nixos.bazarr =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      configDir = "/var/lib/bazarr";
      configFile = "${configDir}/config/config.yaml";
    in
    {
      config = lib.mkIf config.host.features.bazarr.enable {
        services.bazarr.enable = true;
        systemd.services.bazarr.serviceConfig.Restart = lib.mkForce "always";

        sops.templates."bazarr-config" = {
          owner = "bazarr";
          restartUnits = [ "bazarr.service" ];
          content = ''
            analytics:
              enabled: false
            backup:
              folder: /data/backups/hsrv/bazarr
            general:
              enabled_providers:
              - opensubtitlescom
              flask_secret_key: ${config.sops.placeholder."bazarr/flask_secret_key"}
              movie_default_enabled: true
              movie_default_profile: 1
              serie_default_enabled: true
              serie_default_profile: 1
              subzero_mods: remove_tags,OCR_fixes,common
              use_radarr: true
              use_sonarr: true
            opensubtitlescom:
              username: ${config.sops.placeholder."bazarr/opensubtitlescom_username"}
              password: ${config.sops.placeholder."bazarr/opensubtitlescom_password"}
            radarr:
              apikey: ${config.sops.placeholder."radarr/api_key"}
              full_update_hour: 5
              ip: 127.0.0.1
              port: 7878
              ssl: false
            sonarr:
              apikey: ${config.sops.placeholder."sonarr/api_key"}
              ip: 127.0.0.1
              port: 8989
              ssl: false
          '';
        };

        systemd.services.bazarr.preStart = ''
          mkdir -p ${configDir}/config
          install -m 400 -o bazarr -g bazarr ${config.sops.templates."bazarr-config".path} ${configFile}
        '';

        services.caddy.virtualHosts."bazarr.home.nordheim.io".extraConfig = ''
          reverse_proxy localhost:6767
        '';
      };
    };
}
