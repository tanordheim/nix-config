{
      lib,
      config,
      pkgs,
      ...
    }:
    {
      
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
          after = [
            "prowlarr.service"
            "sonarr.service"
            "radarr.service"
            "lidarr.service"
          ];
          wants = [
            "prowlarr.service"
            "sonarr.service"
            "radarr.service"
            "lidarr.service"
          ];
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

            log() { echo "==> $*"; }
            trap 'log "FAILED at line $LINENO (exit $?)"' ERR

            keys=$(cat ${config.sops.templates."prowlarr-apps".path})
            PROWLARR_KEY=$(echo "$keys" | jq -r .prowlarrKey)
            SONARR_KEY=$(echo "$keys" | jq -r .sonarrKey)
            RADARR_KEY=$(echo "$keys" | jq -r .radarrKey)
            LIDARR_KEY=$(echo "$keys" | jq -r .lidarrKey)

            API="http://localhost:9696/api/v1"

            wait_health() {
              local name=$1 url=$2 key=$3
              log "Waiting for $name health at $url"
              for i in $(seq 1 60); do
                curl -sSf "$url" -H "X-Api-Key: $key" > /dev/null && return 0
                sleep 2
              done
              log "  ERROR: $name never became healthy"
              return 1
            }

            wait_health Prowlarr "$API/health" "$PROWLARR_KEY"
            wait_health Sonarr "http://localhost:8989/api/v3/health" "$SONARR_KEY"
            wait_health Radarr "http://localhost:7878/api/v3/health" "$RADARR_KEY"
            wait_health Lidarr "http://localhost:8686/api/v1/health" "$LIDARR_KEY"

            schema=$(curl -sSf "$API/applications/schema" -H "X-Api-Key: $PROWLARR_KEY")

            configure_app() {
              local name=$1 impl=$2 contract=$3 url=$4 key=$5

              log "Configuring Prowlarr app: $name ($impl)"

              default_cats=$(echo "$schema" | jq -c \
                "[.[] | select(.implementation == \"$impl\") | .fields[] | select(.name == \"syncCategories\") | .value] | .[0]")

              if [ "$default_cats" = "null" ] || [ -z "$default_cats" ]; then
                log "  ERROR: implementation '$impl' not found in schema"
                exit 1
              fi

              existing=$(curl -sSf "$API/applications" -H "X-Api-Key: $PROWLARR_KEY")
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

              local response http_code body
              if [ -n "$id" ]; then
                log "  PUT existing id=$id"
                payload=$(echo "$payload" | jq --argjson id "$id" '. + {id: $id}')
                response=$(curl -sS -w "\n%{http_code}" -X PUT "$API/applications/$id" \
                  -H "X-Api-Key: $PROWLARR_KEY" \
                  -H "Content-Type: application/json" \
                  -d "$payload")
              else
                log "  POST new"
                response=$(curl -sS -w "\n%{http_code}" -X POST "$API/applications" \
                  -H "X-Api-Key: $PROWLARR_KEY" \
                  -H "Content-Type: application/json" \
                  -d "$payload")
              fi
              http_code=$(echo "$response" | tail -n1)
              body=$(echo "$response" | sed '$d')
              if [ "$http_code" -lt 200 ] || [ "$http_code" -ge 300 ]; then
                log "  FAILED HTTP $http_code: $body"
                log "  Request payload: $payload"
                exit 1
              fi
              log "  OK ($http_code)"
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
      
    }
