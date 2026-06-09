{
  lib,
  config,
  pkgs,
  ...
}:
{

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-8yZDrejNKsaUnUaTUFYbarWNmxafqp2z2rWo+XRsxV8=";
    };
    globalConfig = ''
      acme_dns cloudflare {env.CF_API_TOKEN}
    '';
  };

  sops.templates."caddy-env" = {
    restartUnits = [ "caddy.service" ];
    content = ''
      CF_API_TOKEN=${config.sops.placeholder."cloudflare/api_token"}
    '';
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.templates."caddy-env".path;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

}
