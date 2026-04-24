{ config, pkgs, ... }:
{
  sops.templates."arr-downloader-keys" = {
    content = builtins.toJSON {
      sonarrKey = config.sops.placeholder."sonarr/api_key";
      radarrKey = config.sops.placeholder."radarr/api_key";
      lidarrKey = config.sops.placeholder."lidarr/api_key";
      sabnzbdKey = config.sops.placeholder."sabnzbd/api_key";
    };
  };

  systemd.services.arr-download-clients-configure = {
    description = "Configure Arr download clients";
    after = [
      "sonarr.service"
      "radarr.service"
      "lidarr.service"
      "qbittorrent.service"
      "sabnzbd.service"
    ];
    wants = [
      "sonarr.service"
      "radarr.service"
      "lidarr.service"
      "qbittorrent.service"
      "sabnzbd.service"
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

      log "Reading API keys from sops template"
      keys=$(cat ${config.sops.templates."arr-downloader-keys".path})
      SONARR_KEY=$(echo "$keys" | jq -r .sonarrKey)
      RADARR_KEY=$(echo "$keys" | jq -r .radarrKey)
      LIDARR_KEY=$(echo "$keys" | jq -r .lidarrKey)
      SABNZBD_KEY=$(echo "$keys" | jq -r .sabnzbdKey)

      log "Waiting for Sonarr health"
      for i in $(seq 1 30); do
        curl -sSf "http://localhost:8989/api/v3/health" -H "X-Api-Key: $SONARR_KEY" > /dev/null && break
        sleep 2
      done
      log "Waiting for Radarr health"
      for i in $(seq 1 30); do
        curl -sSf "http://localhost:7878/api/v3/health" -H "X-Api-Key: $RADARR_KEY" > /dev/null && break
        sleep 2
      done
      log "Waiting for Lidarr health"
      for i in $(seq 1 30); do
        curl -sSf "http://localhost:8686/api/v1/health" -H "X-Api-Key: $LIDARR_KEY" > /dev/null && break
        sleep 2
      done
      log "Waiting for qBittorrent"
      for i in $(seq 1 30); do
        curl -sSf "http://localhost:8181/api/v2/app/version" > /dev/null && break
        sleep 2
      done
      log "Waiting for SABnzbd"
      for i in $(seq 1 30); do
        curl -sSf "http://127.0.0.1:8080/api?mode=version&output=json&apikey=$SABNZBD_KEY" > /dev/null && break
        sleep 2
      done

      log "Fetching qBittorrent categories"
      qbittorrent_categories=$(curl -sSf "http://localhost:8181/api/v2/torrents/categories")
      log "Existing qBittorrent categories: $(echo "$qbittorrent_categories" | jq -c 'keys')"
      for cat in sonarr radarr lidarr; do
        savepath="/data/downloads/complete/qbittorrent/$cat"
        existing_path=$(echo "$qbittorrent_categories" | jq -r --arg c "$cat" '.[$c].savePath // empty')
        if [ "$existing_path" = "$savepath" ]; then
          log "qBittorrent category '$cat' already correct, skipping"
          continue
        fi
        endpoint=$([ -n "$existing_path" ] && echo "editCategory" || echo "createCategory")
        log "qBittorrent $endpoint '$cat' -> $savepath"
        curl -sSf -X POST "http://localhost:8181/api/v2/torrents/$endpoint" \
          --data-urlencode "category=$cat" \
          --data-urlencode "savePath=$savepath" > /dev/null
      done

      configure_client() {
        local arr_url=$1 arr_key=$2 api_version=$3 name=$4 impl=$5 contract=$6 priority=$7 fields_override=$8

        local API="$arr_url/api/$api_version"
        log "[$arr_url] Configuring $name ($impl)"

        local schema
        schema=$(curl -sSf "$API/downloadclient/schema" -H "X-Api-Key: $arr_key")

        local default_fields
        default_fields=$(echo "$schema" | jq -c \
          "[.[] | select(.implementation == \"$impl\") | .fields[] | {name, value}]")

        if [ "$default_fields" = "[]" ] || [ -z "$default_fields" ]; then
          log "  ERROR: implementation '$impl' not found in schema"
          exit 1
        fi
        log "  Schema fields: $(echo "$default_fields" | jq -c 'map(.name)')"

        local fields
        fields=$(echo "$default_fields" | jq -c \
          --argjson overrides "$fields_override" \
          '
            . as $defaults
            | $overrides
            | to_entries
            | reduce .[] as $o (
                $defaults;
                map(if .name == $o.key then .value = $o.value else . end)
              )
          ')

        local existing
        existing=$(curl -sSf "$API/downloadclient" -H "X-Api-Key: $arr_key")

        local id
        id=$(echo "$existing" | jq -r ".[] | select(.implementation == \"$impl\") | .id")

        local payload
        payload=$(jq -n \
          --arg name "$name" \
          --arg impl "$impl" \
          --arg contract "$contract" \
          --argjson priority "$priority" \
          --argjson fields "$fields" \
          '{
            name: $name,
            enable: true,
            protocol: (if $impl == "Sabnzbd" then "usenet" else "torrent" end),
            priority: $priority,
            removeCompletedDownloads: true,
            removeFailedDownloads: true,
            implementation: $impl,
            implementationName: $impl,
            configContract: $contract,
            tags: [],
            fields: $fields
          }')

        local response http_code
        if [ -n "$id" ]; then
          log "  PUT existing id=$id"
          payload=$(echo "$payload" | jq --argjson id "$id" '. + {id: $id}')
          response=$(curl -sS -w "\n%{http_code}" -X PUT "$API/downloadclient/$id" \
            -H "X-Api-Key: $arr_key" \
            -H "Content-Type: application/json" \
            -d "$payload")
        else
          log "  POST new"
          response=$(curl -sS -w "\n%{http_code}" -X POST "$API/downloadclient" \
            -H "X-Api-Key: $arr_key" \
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

      sonarr_qbittorrent_fields=$(jq -n '{
        host: "localhost",
        port: 8181,
        useSsl: false,
        urlBase: "",
        username: "",
        password: "",
        tvCategory: "sonarr"
      }')
      sonarr_sab_fields=$(jq -n --arg key "$SABNZBD_KEY" '{
        host: "127.0.0.1",
        port: 8080,
        useSsl: false,
        urlBase: "",
        apiKey: $key,
        tvCategory: "tv"
      }')
      radarr_qbittorrent_fields=$(jq -n '{
        host: "localhost",
        port: 8181,
        useSsl: false,
        urlBase: "",
        username: "",
        password: "",
        movieCategory: "radarr"
      }')
      radarr_sab_fields=$(jq -n --arg key "$SABNZBD_KEY" '{
        host: "127.0.0.1",
        port: 8080,
        useSsl: false,
        urlBase: "",
        apiKey: $key,
        movieCategory: "movies"
      }')
      lidarr_qbittorrent_fields=$(jq -n '{
        host: "localhost",
        port: 8181,
        useSsl: false,
        urlBase: "",
        username: "",
        password: "",
        musicCategory: "lidarr"
      }')
      lidarr_sab_fields=$(jq -n --arg key "$SABNZBD_KEY" '{
        host: "127.0.0.1",
        port: 8080,
        useSsl: false,
        urlBase: "",
        apiKey: $key,
        musicCategory: "music"
      }')

      configure_client "http://localhost:8989" "$SONARR_KEY" v3 \
        "SABnzbd" "Sabnzbd" "SabnzbdSettings" 1 "$sonarr_sab_fields"
      configure_client "http://localhost:8989" "$SONARR_KEY" v3 \
        "qBittorrent" "QBittorrent" "QBittorrentSettings" 2 "$sonarr_qbittorrent_fields"

      configure_client "http://localhost:7878" "$RADARR_KEY" v3 \
        "SABnzbd" "Sabnzbd" "SabnzbdSettings" 1 "$radarr_sab_fields"
      configure_client "http://localhost:7878" "$RADARR_KEY" v3 \
        "qBittorrent" "QBittorrent" "QBittorrentSettings" 2 "$radarr_qbittorrent_fields"

      configure_client "http://localhost:8686" "$LIDARR_KEY" v1 \
        "SABnzbd" "Sabnzbd" "SabnzbdSettings" 1 "$lidarr_sab_fields"
      configure_client "http://localhost:8686" "$LIDARR_KEY" v1 \
        "qBittorrent" "QBittorrent" "QBittorrentSettings" 2 "$lidarr_qbittorrent_fields"
    '';
  };
}
