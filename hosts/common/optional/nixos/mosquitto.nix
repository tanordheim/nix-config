{ config, ... }:
{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        port = 1883;
        users = {
          zigbee2mqtt = {
            passwordFile = config.sops.secrets."mosquitto/password".path;
            acl = [ "readwrite #" ];
          };
          homeassistant = {
            passwordFile = config.sops.secrets."mosquitto/password".path;
            acl = [ "readwrite #" ];
          };
        };
      }
    ];
  };

  sops.secrets."mosquitto/password" = {
    owner = "mosquitto";
  };

  networking.firewall.allowedTCPPorts = [ 1883 ];
}
