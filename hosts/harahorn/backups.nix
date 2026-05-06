{ config, ... }:
{
  imports = [ ../../modules/nixos/backups ];

  backups = {
    telegram = {
      botTokenFile = config.sops.secrets."telegram/bot_token".path;
      chatIdFile = config.sops.secrets."telegram/chat_id".path;
    };
    heartbeat = {
      repository = "/mnt/nas/backups/harahorn";
      host = "harahorn";
      passwordFile = config.sops.secrets."restic/password".path;
    };
  };

  services.restic.backups.harahorn = {
    repository = "/mnt/nas/backups/harahorn";
    initialize = true;
    paths = [
      "/home/trond"
      "/var/lib/sops-nix/key.txt"
    ];
    extraBackupArgs = [
      "--exclude-file"
      "${./backup-exclude}"
      "--exclude-caches"
      "--one-file-system"
      "--host"
      "harahorn"
    ];
    passwordFile = config.sops.secrets."restic/password".path;
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      RandomizedDelaySec = "30m";
      Persistent = true;
    };
    pruneOpts = [
      "--keep-daily 14"
      "--keep-weekly 8"
      "--keep-monthly 12"
    ];
  };

  systemd.services.restic-backups-harahorn.unitConfig = {
    OnFailure = [ "telegram-notify@%n.service" ];
    RequiresMountsFor = [ "/mnt/nas/backups" ];
  };

  systemd.services.restic-heartbeat.unitConfig.RequiresMountsFor = [ "/mnt/nas/backups" ];
}
