{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.backups;

  notifyScript = pkgs.writeShellApplication {
    name = "telegram-notify";
    runtimeInputs = [
      pkgs.curl
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail
      message="$1"
      token=$(cat "${cfg.telegram.botTokenFile}")
      chat=$(cat "${cfg.telegram.chatIdFile}")
      curl -sS -X POST "https://api.telegram.org/bot''${token}/sendMessage" \
        --data-urlencode "chat_id=''${chat}" \
        --data-urlencode "parse_mode=Markdown" \
        --data-urlencode "text=''${message}" >/dev/null
    '';
  };

  notifyOnFailureScript = pkgs.writeShellApplication {
    name = "telegram-notify-on-failure";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.systemd
      notifyScript
    ];
    text = ''
      set -euo pipefail
      unit="$1"
      host=$(uname -n)
      tail=$(journalctl -u "$unit" -n 20 --no-pager 2>&1 || echo "(no journal output)")
      msg="❌ *''${host}* unit failed: \`''${unit}\`

\`\`\`
''${tail}
\`\`\`"
      telegram-notify "$msg"
    '';
  };

  heartbeatScript = pkgs.writeShellApplication {
    name = "restic-heartbeat";
    runtimeInputs = [
      pkgs.restic
      pkgs.jq
      pkgs.coreutils
      pkgs.gawk
      notifyScript
    ];
    text = ''
      set -euo pipefail
      export RESTIC_REPOSITORY="${cfg.heartbeat.repository}"
      export RESTIC_PASSWORD_FILE="${cfg.heartbeat.passwordFile}"

      host="${cfg.heartbeat.host}"

      now=$(date +%s)
      seven_days_ago=$((now - 7 * 24 * 3600))

      snapshots=$(restic snapshots --host "$host" --json)
      total=$(echo "$snapshots" | jq 'length')
      recent=$(echo "$snapshots" | jq --argjson t "$seven_days_ago" '[.[] | select((.time | fromdateiso8601) >= $t)] | length')
      latest=$(echo "$snapshots" | jq -r 'if length > 0 then .[-1].time else "none" end')

      stats=$(restic stats --mode raw-data --json)
      size_bytes=$(echo "$stats" | jq '.total_size')
      size_gb=$(awk "BEGIN { printf \"%.2f\", ''${size_bytes} / (1024 * 1024 * 1024) }")

      msg="✅ *''${host}* backup heartbeat
last 7 days: ''${recent} snapshots
total snapshots: ''${total}
latest: ''${latest}
repo size: ''${size_gb} GB"

      telegram-notify "$msg"
    '';
  };
in
{
  options.backups = {
    telegram = {
      botTokenFile = lib.mkOption {
        type = lib.types.path;
        description = "Path to file containing the Telegram bot token";
      };
      chatIdFile = lib.mkOption {
        type = lib.types.path;
        description = "Path to file containing the Telegram chat ID";
      };
    };

    heartbeat = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      repository = lib.mkOption {
        type = lib.types.str;
        description = "Restic repository path to summarize";
      };
      host = lib.mkOption {
        type = lib.types.str;
        description = "Host filter for restic snapshots";
      };
      passwordFile = lib.mkOption {
        type = lib.types.path;
        description = "Path to file containing the restic repo password";
      };
      calendar = lib.mkOption {
        type = lib.types.str;
        default = "Sun 09:00";
      };
    };
  };

  config = {
    systemd.services."telegram-notify@" = {
      description = "Send Telegram failure notification for %i";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${notifyOnFailureScript}/bin/telegram-notify-on-failure %i";
      };
    };

    systemd.services.restic-heartbeat = lib.mkIf cfg.heartbeat.enable {
      description = "Restic backup heartbeat to Telegram";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${heartbeatScript}/bin/restic-heartbeat";
      };
      unitConfig.OnFailure = [ "telegram-notify@%n.service" ];
    };

    systemd.timers.restic-heartbeat = lib.mkIf cfg.heartbeat.enable {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.heartbeat.calendar;
        Persistent = true;
      };
    };
  };
}
