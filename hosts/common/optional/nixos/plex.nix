{ lib, ... }:
{
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  systemd.services.plex.serviceConfig.Restart = lib.mkForce "always";

  networking.firewall.allowedUDPPorts = [
    32410
    32412
    32413
    32414
  ];

  services.caddy.virtualHosts."plex.home.nordheim.io".extraConfig = ''
    reverse_proxy localhost:32400
  '';
}
