{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../secrets/hsrv.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets = {
      "cloudflare/api_token" = { };
      "mosquitto/user" = { };
      "mosquitto/password" = { };
      "sonarr/api_key" = { };
      "radarr/api_key" = { };
      "prowlarr/api_key" = { };
      "sabnzbd/servers" = { };
      "sabnzbd/api_key" = { };
      "sabnzbd/nzb_key" = { };
      "bazarr/opensubtitlescom_username" = { };
      "bazarr/opensubtitlescom_password" = { };
      "bazarr/flask_secret_key" = { };
    };
  };
}
