{
  flake.modules.nixos.sabnzbd =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.sabnzbd.enable {
        services.sabnzbd = {
          enable = true;
          secretFiles = [
            config.sops.templates."sabnzbd-secrets".path
          ];
          settings = {
            misc = {
              port = 8080;
              host = "127.0.0.1";
              host_whitelist = "sabnzbd.home.nordheim.io";
              cache_limit = "1G";
              bandwidth_perc = 100;
              download_dir = "/data/downloads/incomplete/sabnzbd";
              complete_dir = "/data/downloads/complete/sabnzbd";
              helpful_warnings = false;
            };
            categories = {
              "*" = {
                name = "*";
                pp = 3;
                script = "None";
                dir = "";
                newzbin = "";
                priority = 0;
              };
              movies = {
                name = "movies";
                pp = "";
                script = "Default";
                dir = "";
                newzbin = "";
                priority = -100;
              };
              tv = {
                name = "tv";
                pp = "";
                script = "Default";
                dir = "";
                newzbin = "";
                priority = -100;
              };
              software = {
                name = "software";
                pp = "";
                script = "Default";
                dir = "";
                newzbin = "";
                priority = -100;
              };
              audiobooks = {
                name = "audiobooks";
                pp = "";
                script = "Default";
                dir = "";
                newzbin = "";
                priority = -100;
              };
              readarr = {
                name = "readarr";
                pp = "";
                script = "Default";
                dir = "";
                newzbin = "";
                priority = -100;
              };
            };
          };
        };

        sops.templates."sabnzbd-secrets" = {
          owner = "sabnzbd";
          restartUnits = [ "sabnzbd.service" ];
          content = ''
            [misc]
            api_key = ${config.sops.placeholder."sabnzbd/api_key"}
            nzb_key = ${config.sops.placeholder."sabnzbd/nzb_key"}
            [servers]
            ${config.sops.placeholder."sabnzbd/servers"}
          '';
        };

        services.caddy.virtualHosts."sabnzbd.home.nordheim.io".extraConfig = ''
          reverse_proxy localhost:8080
        '';
      };
    };
}
