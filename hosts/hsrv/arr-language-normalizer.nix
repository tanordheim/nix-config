{
  config,
  lib,
  pkgs,
  ...
}:
let
  normalizer = pkgs.writeShellApplication {
    name = "normalize-mkv-norwegian";
    runtimeInputs = [
      pkgs.findutils
      pkgs.jq
      pkgs.mkvtoolnix-cli
    ];
    text = ''
      set -euo pipefail

      normalize_file() {
        local file=$1 metadata uids

        if [[ ''${file,,} != *.mkv ]]; then
          return
        fi

        if ! metadata=$(mkvmerge --identification-format json --identify "$file"); then
          printf 'Failed to inspect MKV: %s\n' "$file" >&2
          return 1
        fi
        if ! uids=$(jq -r '
          if .container.recognized != true or (.tracks | type) != "array" then
            error("not a recognized Matroska file")
          else
            .tracks[]
            | select(.type == "audio")
            | select(
                ((.properties.language // "") | ascii_downcase) as $language
                | ((.properties.language_ietf // "") | ascii_downcase | split("-")[0]) as $language_ietf
                | ($language == "nob" or $language == "nno" or $language == "nb" or $language == "nn"
                   or $language_ietf == "nob" or $language_ietf == "nno"
                   or $language_ietf == "nb" or $language_ietf == "nn")
              )
            | .properties.uid
          end
        ' <<< "$metadata"); then
          printf 'Failed to read MKV tracks: %s\n' "$file" >&2
          return 1
        fi

        if [[ -z $uids ]]; then
          return
        fi

        local -a edits=()
        local uid
        while IFS= read -r uid; do
          edits+=(--edit "track:=$uid" --set language=nor)
        done <<< "$uids"

        printf 'Normalizing Norwegian audio tracks: %s\n' "$file"
        mkvpropedit "$file" "''${edits[@]}"
      }

      normalize_path() {
        local path=$1 failed=0

        if [[ -d $path ]]; then
          while IFS= read -r -d "" file; do
            normalize_file "$file" || failed=1
          done < <(find "$path" -type f -iname "*.mkv" -print0)
        elif [[ -f $path ]]; then
          normalize_file "$path" || failed=1
        else
          printf 'Path does not exist: %s\n' "$path" >&2
          return 1
        fi

        return "$failed"
      }

      if (( $# > 0 )); then
        failed=0
        for path in "$@"; do
          normalize_path "$path" || failed=1
        done
        exit "$failed"
      elif [[ ''${sonarr_eventtype:-} == Download && -n ''${sonarr_episodefile_path:-} ]]; then
        normalize_file "$sonarr_episodefile_path"
      elif [[ ''${radarr_eventtype:-} == Download && -n ''${radarr_moviefile_path:-} ]]; then
        normalize_file "$radarr_moviefile_path"
      elif [[ ''${sonarr_eventtype:-} == Test || ''${radarr_eventtype:-} == Test ]]; then
        exit 0
      else
        printf 'Usage: normalize-mkv-norwegian PATH...\n' >&2
        exit 2
      fi
    '';
  };
in
{
  sops.templates."arr-language-normalizer-keys" = {
    restartUnits = [ "arr-language-normalizer-configure.service" ];
    content = builtins.toJSON {
      sonarrKey = config.sops.placeholder."sonarr/api_key";
      radarrKey = config.sops.placeholder."radarr/api_key";
    };
  };

  environment.systemPackages = [
    normalizer
    pkgs.mkvtoolnix-cli
  ];

  systemd.services.arr-language-normalizer-configure = {
    description = "Configure Arr Norwegian audio normalization";
    after = [
      "sonarr.service"
      "radarr.service"
    ];
    wants = [
      "sonarr.service"
      "radarr.service"
    ];
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.coreutils
      pkgs.curl
      pkgs.gnused
      pkgs.jq
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = 30;
      TimeoutStartSec = 180;
    };
    script = ''
      set -euo pipefail

      keys=$(cat ${config.sops.templates."arr-language-normalizer-keys".path})
      SONARR_KEY=$(echo "$keys" | jq -r .sonarrKey)
      RADARR_KEY=$(echo "$keys" | jq -r .radarrKey)

      wait_for_arr() {
        local url=$1 key=$2

        for _ in $(seq 1 30); do
          curl -sSf "$url/api/v3/health" -H "X-Api-Key: $key" > /dev/null && return
          sleep 2
        done

        printf 'Timed out waiting for %s\n' "$url" >&2
        return 1
      }

      configure_connection() {
        local url=$1 key=$2 name="Normalize Norwegian audio"
        local api="$url/api/v3" schema existing id payload response http_code body

        schema=$(curl -sSf "$api/notification/schema" -H "X-Api-Key: $key" \
          | jq -c '[.[] | select(.implementation == "CustomScript")][0] // empty')
        if [[ -z $schema ]]; then
          printf 'CustomScript notification schema not found for %s\n' "$url" >&2
          return 1
        fi

        payload=$(jq -c \
          --arg name "$name" \
          --arg path "${lib.getExe normalizer}" \
          '
            .name = $name
            | .enable = true
            | .onDownload = true
            | .onUpgrade = true
            | .tags = []
            | .fields |= map(if .name == "path" then .value = $path else . end)
            | del(.id)
          ' <<< "$schema")

        existing=$(curl -sSf "$api/notification" -H "X-Api-Key: $key")
        id=$(jq -r --arg name "$name" '.[] | select(.name == $name) | .id' <<< "$existing")

        if [[ -n $id ]]; then
          payload=$(jq --argjson id "$id" '. + {id: $id}' <<< "$payload")
          response=$(curl -sS -w "\n%{http_code}" -X PUT "$api/notification/$id?forceSave=true" \
            -H "X-Api-Key: $key" \
            -H "Content-Type: application/json" \
            -d "$payload")
        else
          response=$(curl -sS -w "\n%{http_code}" -X POST "$api/notification?forceSave=true" \
            -H "X-Api-Key: $key" \
            -H "Content-Type: application/json" \
            -d "$payload")
        fi

        http_code=$(tail -n1 <<< "$response")
        body=$(sed '$d' <<< "$response")
        if (( http_code < 200 || http_code >= 300 )); then
          printf 'Failed to configure %s: HTTP %s: %s\n' "$url" "$http_code" "$body" >&2
          return 1
        fi
      }

      wait_for_arr "http://localhost:8989" "$SONARR_KEY"
      wait_for_arr "http://localhost:7878" "$RADARR_KEY"
      configure_connection "http://localhost:8989" "$SONARR_KEY"
      configure_connection "http://localhost:7878" "$RADARR_KEY"
    '';
  };
}
