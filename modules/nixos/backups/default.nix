{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.backups;

  desktopNotifyScript = pkgs.writeShellApplication {
    name = "desktop-notify";
    runtimeInputs = [
      pkgs.libnotify
      pkgs.coreutils
      pkgs.sudo
    ];
    text = ''
      set -eu
      urgency="$1"
      summary="$2"
      body="$3"
      user="trond"
      uid=$(id -u "$user" 2>/dev/null || true)
      [ -n "$uid" ] && [ -S "/run/user/$uid/bus" ] || exit 0
      sudo -u "$user" \
        DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus" \
        notify-send -u "$urgency" "$summary" "$body" || true
    '';
  };

  telegramSendScript = pkgs.writeShellApplication {
    name = "telegram-send";
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

  backupNotifyStartedScript = pkgs.writeShellApplication {
    name = "backup-notify-started";
    runtimeInputs = [ desktopNotifyScript ];
    text = ''
      set -eu
      unit="$1"
      desktop-notify normal "🟡 Backup starting" "$unit"
    '';
  };

  backupNotifyCompletedScript = pkgs.writeShellApplication {
    name = "backup-notify-completed";
    runtimeInputs = [ desktopNotifyScript ];
    text = ''
      set -eu
      unit="$1"
      desktop-notify normal "✅ Backup complete" "$unit"
    '';
  };

  backupNotifyFailedScript = pkgs.writeShellApplication {
    name = "backup-notify-failed";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.systemd
      desktopNotifyScript
      telegramSendScript
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
      telegram-send "$msg" || true
      desktop-notify critical "❌ Backup failed" "$unit"
    '';
  };

  heartbeatScript = pkgs.writeShellApplication {
    name = "restic-heartbeat";
    runtimeInputs = [
      pkgs.restic
      pkgs.jq
      pkgs.coreutils
      pkgs.gawk
      telegramSendScript
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

      recent=0
      while IFS= read -r ts; do
        [ -z "$ts" ] && continue
        s=$(date -d "$ts" +%s 2>/dev/null || echo 0)
        if [ "$s" -ge "$seven_days_ago" ]; then
          recent=$((recent + 1))
        fi
      done < <(echo "$snapshots" | jq -r '.[].time')

      latest=$(echo "$snapshots" | jq -r 'if length > 0 then .[-1].time else "none" end')

      stats=$(restic stats --mode raw-data --json)
      size_bytes=$(echo "$stats" | jq '.total_size')
      size_gb=$(awk "BEGIN { printf \"%.2f\", ''${size_bytes} / (1024 * 1024 * 1024) }")

      msg="✅ *''${host}* backup heartbeat
last 7 days: ''${recent} snapshots
total snapshots: ''${total}
latest: ''${latest}
repo size: ''${size_gb} GB"

      telegram-send "$msg"
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
    environment.systemPackages = [ pkgs.restic ];

    systemd.services."backup-notify-started@" = {
      description = "Backup notification: %i started";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${backupNotifyStartedScript}/bin/backup-notify-started %i";
      };
    };

    systemd.services."backup-notify-completed@" = {
      description = "Backup notification: %i completed";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${backupNotifyCompletedScript}/bin/backup-notify-completed %i";
      };
    };

    systemd.services."backup-notify-failed@" = {
      description = "Backup notification: %i failed";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${backupNotifyFailedScript}/bin/backup-notify-failed %i";
      };
    };

    systemd.services.restic-heartbeat = lib.mkIf cfg.heartbeat.enable {
      description = "Restic backup heartbeat to Telegram";
      environment.HOME = "/root";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${heartbeatScript}/bin/restic-heartbeat";
      };
      unitConfig.OnFailure = [ "backup-notify-failed@%n.service" ];
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
