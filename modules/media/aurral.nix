{
  flake.modules.nixos.aurral =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.aurral.enable {
        systemd.services.aurral = {
          description = "Aurral — Lidarr request manager";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];

          environment = {
            NODE_ENV = "production";
            PORT = "3001";
            AURRAL_DATA_DIR = "/var/lib/aurral";
            AUTH_PROXY_ENABLED = "true";
            AUTH_PROXY_HEADER = "x-forwarded-user";
          };

          serviceConfig = {
            ExecStart = lib.getExe pkgs.aurral;
            Restart = "always";
            RestartSec = 5;
            DynamicUser = true;
            StateDirectory = "aurral";
            WorkingDirectory = "/var/lib/aurral";
            ProtectSystem = "strict";
            ProtectHome = true;
            PrivateTmp = true;
            NoNewPrivileges = true;
          };
        };

        services.caddy.virtualHosts."aurral.home.nordheim.io".extraConfig = ''
          reverse_proxy localhost:3001 {
            header_up X-Forwarded-User local
          }
        '';
      };
    };
}
