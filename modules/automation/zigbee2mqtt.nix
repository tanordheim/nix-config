{
  flake.modules.nixos.zigbee2mqtt =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.zigbee2mqtt.enable {
        services.zigbee2mqtt = {
          enable = true;
          settings = {
            mqtt = {
              server = "mqtt://localhost:1883";
              user = "zigbee2mqtt";
              password = "!secret mqtt_password";
            };
            serial = {
              port = "/dev/ttyACM0";
              adapter = "deconz";
            };
            frontend.port = 8090;
            homeassistant.enabled = true;
          };
        };

        sops.templates."zigbee2mqtt-secrets" = {
          owner = "zigbee2mqtt";
          path = "/var/lib/zigbee2mqtt/secret.yaml";
          restartUnits = [ "zigbee2mqtt.service" ];
          content = ''
            mqtt_password: ${config.sops.placeholder."mosquitto/password"}
          '';
        };

        services.caddy.virtualHosts."z2m.home.nordheim.io".extraConfig = ''
          reverse_proxy localhost:8090
        '';
      };
    };
}
