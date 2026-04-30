{
      lib,
      config,
      pkgs,
      ...
    }:
    {
      
        services.home-assistant = {
          enable = true;
          extraComponents = [
            "default_config"
            "met"
            "mqtt"
            "google_translate"
            "ffmpeg"
            "melcloud"
            "denonavr"
            "hue"
            "unifi"
            "co2signal"
            "ipp"
            "unifiprotect"
            "aranet"
            "ruuvitag_ble"
            "tibber"
            "spotify"
            "cast"
            "radio_browser"
          ];
          config = {
            homeassistant = {
              name = "Home";
              unit_system = "metric";
              time_zone = "Europe/Oslo";
            };
            http = {
              server_port = 8123;
              use_x_forwarded_for = true;
              trusted_proxies = [
                "127.0.0.1"
                "::1"
              ];
            };
            tts = [
              { platform = "google_translate"; }
            ];
            ffmpeg = { };
            automation = "!include automations.yaml";
            script = "!include scripts.yaml";
            scene = "!include scenes.yaml";
          };
        };

        systemd.services.home-assistant.preStart = ''
          cd /var/lib/hass
          for f in automations.yaml scripts.yaml scenes.yaml; do
            [ -f "$f" ] || echo "[]" > "$f"
          done
        '';

        sops.templates."hass-secrets" = {
          owner = "hass";
          path = "/var/lib/hass/secrets.yaml";
          restartUnits = [ "home-assistant.service" ];
          content = ''
            mqtt_password: ${config.sops.placeholder."mosquitto/password"}
          '';
        };

        systemd.services.home-assistant.serviceConfig.Restart = lib.mkForce "always";

        services.caddy.virtualHosts."ha.home.nordheim.io".extraConfig = ''
          reverse_proxy localhost:8123
        '';
      
    }
