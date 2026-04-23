{
  flake.modules.nixos.qbittorrent =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      configDir = "/var/lib/qbittorrent/.config/qBittorrent";
      configFile = "${configDir}/qBittorrent.conf";
    in
    {
      config = lib.mkIf config.host.features.qbittorrent.enable {
        users.users.qbittorrent = {
          isSystemUser = true;
          group = "qbittorrent";
          home = "/var/lib/qbittorrent";
        };
        users.groups.qbittorrent = { };

        systemd.services.qbittorrent = {
          description = "qBittorrent-nox";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          preStart = ''
            mkdir -p ${configDir}
            install -m 400 -o qbittorrent -g qbittorrent /dev/stdin ${configFile} << 'EOF'
            [BitTorrent]
            Session\AnonymousModeEnabled=true
            Session\DefaultSavePath=/data/downloads/complete/qbittorrent
            Session\GlobalMaxRatio=10
            Session\GlobalMaxSeedingMinutes=86400
            Session\Port=53016
            Session\ShareLimitAction=Stop
            Session\TempPath=/data/downloads/incomplete/qbittorrent
            Session\TempPathEnabled=true

            [LegalNotice]
            Accepted=true

            [Preferences]
            Connection\UPnP=false
            WebUI\LocalHostAuth=false
            WebUI\Port=8181
            EOF
          '';
          serviceConfig = {
            ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=8181";
            User = "qbittorrent";
            Group = "qbittorrent";
            StateDirectory = "qbittorrent";
            Restart = "always";
          };
        };

        networking.firewall = {
          allowedTCPPorts = [ 53016 ];
          allowedUDPPorts = [
            6881
            53016
          ];
        };

        services.caddy.virtualHosts."qbittorrent.home.nordheim.io".extraConfig = ''
          reverse_proxy localhost:8181
        '';
      };
    };
}
