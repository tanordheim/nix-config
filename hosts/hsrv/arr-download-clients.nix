{ config, pkgs, ... }:
{
  sops.templates."arr-downloader-keys" = {
    content = builtins.toJSON {
      sonarrKey = config.sops.placeholder."sonarr/api_key";
      radarrKey = config.sops.placeholder."radarr/api_key";
      sabnzbdKey = config.sops.placeholder."sabnzbd/api_key";
    };
  };

  systemd.services.arr-download-clients-configure = {
    description = "Configure Sonarr/Radarr download clients";
    after = [
      "sonarr.service"
      "radarr.service"
      "qbittorrent.service"
      "sabnzbd.service"
    ];
    wants = [
      "sonarr.service"
      "radarr.service"
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

      keys=$(cat ${config.sops.templates."arr-downloader-keys".path})
      SONARR_KEY=$(echo "$keys" | jq -r .sonarrKey)
      RADARR_KEY=$(echo "$keys" | jq -r .radarrKey)
      SABNZBD_KEY=$(echo "$keys" | jq -r .sabnzbdKey)

      for i in $(seq 1 30); do
        curl -sf "http://localhost:8989/api/v3/health" -H "X-Api-Key: $SONARR_KEY" > /dev/null && break
        sleep 2
      done
      for i in $(seq 1 30); do
        curl -sf "http://localhost:7878/api/v3/health" -H "X-Api-Key: $RADARR_KEY" > /dev/null && break
        sleep 2
      done
      for i in $(seq 1 30); do
        curl -sf "http://localhost:8181/api/v2/app/version" > /dev/null && break
        sleep 2
      done
      for i in $(seq 1 30); do
        curl -sf "http://127.0.0.1:8080/api?mode=version&output=json&apikey=$SABNZBD_KEY" > /dev/null && break
        sleep 2
      done

      for cat in sonarr radarr; do
        mkdir -p "/data/downloads/complete/qbittorrent/$cat"
        curl -sf -X POST "http://localhost:8181/api/v2/torrents/createCategory" \
          --data-urlencode "category=$cat" \
          --data-urlencode "savePath=/data/downloads/complete/qbittorrent/$cat" \
          > /dev/null
      done

      configure_client() {
        local arr_url=$1 arr_key=$2 name=$3 impl=$4 contract=$5 priority=$6 fields_override=$7

        local API="$arr_url/api/v3"

        local schema
        schema=$(curl -sf "$API/downloadclient/schema" -H "X-Api-Key: $arr_key")

        local default_fields
        default_fields=$(echo "$schema" | jq -c \
          "[.[] | select(.implementation == \"$impl\") | .fields[] | {name, value}]")

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
        existing=$(curl -sf "$API/downloadclient" -H "X-Api-Key: $arr_key")

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

        if [ -n "$id" ]; then
          payload=$(echo "$payload" | jq --argjson id "$id" '. + {id: $id}')
          curl -sf -X PUT "$API/downloadclient/$id" \
            -H "X-Api-Key: $arr_key" \
            -H "Content-Type: application/json" \
            -d "$payload" > /dev/null
        else
          curl -sf -X POST "$API/downloadclient" \
            -H "X-Api-Key: $arr_key" \
            -H "Content-Type: application/json" \
            -d "$payload" > /dev/null
        fi
      }

      sonarr_qbit_fields=$(jq -n '{
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
      radarr_qbit_fields=$(jq -n '{
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

      configure_client "http://localhost:8989" "$SONARR_KEY" \
        "SABnzbd" "Sabnzbd" "SabnzbdSettings" 1 "$sonarr_sab_fields"
      configure_client "http://localhost:8989" "$SONARR_KEY" \
        "qBittorrent" "QBittorrent" "QBittorrentSettings" 2 "$sonarr_qbit_fields"

      configure_client "http://localhost:7878" "$RADARR_KEY" \
        "SABnzbd" "Sabnzbd" "SabnzbdSettings" 1 "$radarr_sab_fields"
      configure_client "http://localhost:7878" "$RADARR_KEY" \
        "qBittorrent" "QBittorrent" "QBittorrentSettings" 2 "$radarr_qbit_fields"
    '';
  };
}
