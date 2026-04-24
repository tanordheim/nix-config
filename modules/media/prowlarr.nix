{
  flake.modules.nixos.prowlarr =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.prowlarr.enable {
        services.prowlarr.enable = true;
        systemd.services.prowlarr.serviceConfig.Restart = lib.mkForce "always";

        services.prowlarr.environmentFiles = [
          config.sops.templates."prowlarr-env".path
        ];

        sops.templates."prowlarr-env" = {
          restartUnits = [ "prowlarr.service" ];
          content = ''
            PROWLARR__AUTH__APIKEY=${config.sops.placeholder."prowlarr/api_key"}
            PROWLARR__AUTH__METHOD=External
            PROWLARR__AUTH__REQUIRED=DisabledForLocalAddresses
            PROWLARR__MAIN__BACKUPFOLDER=/data/backups/hsrv/prowlarr
          '';
        };

        sops.templates."prowlarr-apps" = {
          content = builtins.toJSON {
            prowlarrKey = config.sops.placeholder."prowlarr/api_key";
            sonarrKey = config.sops.placeholder."sonarr/api_key";
            radarrKey = config.sops.placeholder."radarr/api_key";
            lidarrKey = config.sops.placeholder."lidarr/api_key";
          };
        };

        systemd.services.prowlarr-configure = {
          description = "Configure Prowlarr application connections";
          after = [ "prowlarr.service" ];
          wants = [ "prowlarr.service" ];
          wantedBy = [ "multi-user.target" ];
          path = [
            pkgs.curl
            pkgs.jq
          ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            set -euo pipefail

            keys=$(cat ${config.sops.templates."prowlarr-apps".path})
            PROWLARR_KEY=$(echo "$keys" | jq -r .prowlarrKey)
            SONARR_KEY=$(echo "$keys" | jq -r .sonarrKey)
            RADARR_KEY=$(echo "$keys" | jq -r .radarrKey)
            LIDARR_KEY=$(echo "$keys" | jq -r .lidarrKey)

            API="http://localhost:9696/api/v1"

            for i in $(seq 1 30); do
              curl -sf "$API/health" -H "X-Api-Key: $PROWLARR_KEY" > /dev/null && break
              sleep 2
            done

            schema=$(curl -sf "$API/applications/schema" -H "X-Api-Key: $PROWLARR_KEY")

            configure_app() {
              local name=$1 impl=$2 contract=$3 url=$4 key=$5

              default_cats=$(echo "$schema" | jq -c \
                "[.[] | select(.implementation == \"$impl\") | .fields[] | select(.name == \"syncCategories\") | .value] | .[0]")

              existing=$(curl -sf "$API/applications" -H "X-Api-Key: $PROWLARR_KEY")
              id=$(echo "$existing" | jq -r ".[] | select(.implementation == \"$impl\") | .id")

              payload=$(jq -n \
                --arg name "$name" \
                --arg impl "$impl" \
                --arg contract "$contract" \
                --arg url "$url" \
                --arg key "$key" \
                --argjson cats "$default_cats" \
                '{
                  name: $name,
                  syncLevel: "fullSync",
                  implementation: $impl,
                  implementationName: $impl,
                  configContract: $contract,
                  tags: [],
                  fields: [
                    {name: "prowlarrUrl", value: "http://localhost:9696"},
                    {name: "baseUrl", value: $url},
                    {name: "apiKey", value: $key},
                    {name: "syncCategories", value: $cats}
                  ]
                }')

              if [ -n "$id" ]; then
                payload=$(echo "$payload" | jq --argjson id "$id" '. + {id: $id}')
                curl -sf -X PUT "$API/applications/$id" \
                  -H "X-Api-Key: $PROWLARR_KEY" \
                  -H "Content-Type: application/json" \
                  -d "$payload" > /dev/null
              else
                curl -sf -X POST "$API/applications" \
                  -H "X-Api-Key: $PROWLARR_KEY" \
                  -H "Content-Type: application/json" \
                  -d "$payload" > /dev/null
              fi
            }

            configure_app "Sonarr" "Sonarr" "SonarrSettings" \
              "http://localhost:8989" "$SONARR_KEY"

            configure_app "Radarr" "Radarr" "RadarrSettings" \
              "http://localhost:7878" "$RADARR_KEY"

            configure_app "Lidarr" "Lidarr" "LidarrSettings" \
              "http://localhost:8686" "$LIDARR_KEY"
          '';
        };

        services.caddy.virtualHosts."prowlarr.home.nordheim.io".extraConfig = ''
          reverse_proxy localhost:9696
        '';
      };
    };
}
