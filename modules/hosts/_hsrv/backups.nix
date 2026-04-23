{
  systemd.services.backup-plex = {
    description = "Backup Plex library database";
    serviceConfig.Type = "oneshot";
    path = [ "/run/current-system/sw" ];
    script = ''
      set -euo pipefail
      dir=/data/backups/hsrv/plex
      mkdir -p "$dir"
      dbdir="/var/lib/plex/Plex Media Server/Plug-in Support/Databases"
      tmp=$(mktemp -d)
      for db in "$dbdir"/*.db; do
        [ -f "$db" ] || continue
        name=$(basename "$db")
        sqlite3 "$db" ".backup '$tmp/$name'"
      done
      cp "/var/lib/plex/Plex Media Server/Preferences.xml" "$tmp/"
      tar czf "$dir/plex-$(date +%Y%m%d).tar.gz" -C "$tmp" .
      rm -rf "$tmp"
      find "$dir" -name "plex-*.tar.gz" -mtime +14 -delete
    '';
  };

  systemd.services.backup-sabnzbd = {
    description = "Backup SABnzbd state";
    serviceConfig.Type = "oneshot";
    script = ''
      set -euo pipefail
      dir=/data/backups/hsrv/sabnzbd
      mkdir -p "$dir"
      tar czf "$dir/sabnzbd-$(date +%Y%m%d).tar.gz" -C /var/lib/sabnzbd admin/
      find "$dir" -name "sabnzbd-*.tar.gz" -mtime +14 -delete
    '';
  };

  systemd.services.backup-qbittorrent = {
    description = "Backup qBittorrent state";
    serviceConfig.Type = "oneshot";
    script = ''
      set -euo pipefail
      dir=/data/backups/hsrv/qbittorrent
      mkdir -p "$dir"
      tar czf "$dir/qbittorrent-$(date +%Y%m%d).tar.gz" -C /var/lib/qbittorrent .config/qBittorrent/BT_backup/
      find "$dir" -name "qbittorrent-*.tar.gz" -mtime +14 -delete
    '';
  };

  systemd.services.backup-home-assistant = {
    description = "Backup Home Assistant state";
    serviceConfig.Type = "oneshot";
    path = [ "/run/current-system/sw" ];
    script = ''
      set -euo pipefail
      dir=/data/backups/hsrv/home-assistant
      mkdir -p "$dir"
      tmp=$(mktemp -d)
      for db in /var/lib/hass/*.db; do
        [ -f "$db" ] || continue
        name=$(basename "$db")
        sqlite3 "$db" ".backup '$tmp/$name'"
      done
      cp /var/lib/hass/.storage -r "$tmp/storage"
      tar czf "$dir/home-assistant-$(date +%Y%m%d).tar.gz" -C "$tmp" .
      rm -rf "$tmp"
      find "$dir" -name "home-assistant-*.tar.gz" -mtime +14 -delete
    '';
  };

  systemd.services.backup-zigbee2mqtt = {
    description = "Backup Zigbee2MQTT state";
    serviceConfig.Type = "oneshot";
    script = ''
      set -euo pipefail
      dir=/data/backups/hsrv/zigbee2mqtt
      mkdir -p "$dir"
      tar czf "$dir/zigbee2mqtt-$(date +%Y%m%d).tar.gz" -C /var/lib/zigbee2mqtt database.db devices.yaml groups.yaml
      find "$dir" -name "zigbee2mqtt-*.tar.gz" -mtime +14 -delete
    '';
  };

  systemd.timers.backup-plex = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
      Persistent = true;
    };
  };

  systemd.timers.backup-sabnzbd = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
      Persistent = true;
    };
  };

  systemd.timers.backup-qbittorrent = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
      Persistent = true;
    };
  };

  systemd.timers.backup-home-assistant = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
      Persistent = true;
    };
  };

  systemd.timers.backup-zigbee2mqtt = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
      Persistent = true;
    };
  };
}
