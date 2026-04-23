{
  flake.modules.nixos.unpackerr =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.unpackerr.enable {
        users.users.unpackerr = {
          isSystemUser = true;
          group = "unpackerr";
        };
        users.groups.unpackerr = { };

        sops.templates."unpackerr-env" = {
          content = ''
            UN_SONARR_0_URL=http://localhost:8989
            UN_SONARR_0_API_KEY=${config.sops.placeholder."sonarr/api_key"}
            UN_SONARR_0_PATHS_0=/data/downloads
            UN_RADARR_0_URL=http://localhost:7878
            UN_RADARR_0_API_KEY=${config.sops.placeholder."radarr/api_key"}
            UN_RADARR_0_PATHS_0=/data/downloads
          '';
          owner = "unpackerr";
          restartUnits = [ "unpackerr.service" ];
        };

        systemd.services.unpackerr = {
          description = "Unpackerr";
          after = [
            "network.target"
            "sonarr.service"
            "radarr.service"
          ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.unpackerr}/bin/unpackerr";
            User = "unpackerr";
            Group = "unpackerr";
            StateDirectory = "unpackerr";
            EnvironmentFile = config.sops.templates."unpackerr-env".path;
            Restart = "always";
          };
        };
      };
    };
}
