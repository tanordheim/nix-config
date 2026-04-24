{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  configurations.nixos.hsrv.module =
    { config, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        ./_hsrv/hardware-configuration.nix
        ./_hsrv/sops.nix
        ./_hsrv/arr-download-clients.nix
        ./_hsrv/backups.nix
      ]
      ++ lib.attrValues nixos;

      home-manager.users.trond = {
        imports = lib.attrValues homeManager;
        host.features = config.host.features;
      };

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "26.05";
      networking.hostName = "hsrv";
      networking.interfaces.eno1.ipv4.addresses = [
        {
          address = "192.168.69.10";
          prefixLength = 24;
        }
      ];
      networking.defaultGateway = "192.168.69.1";
      networking.nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];

      home-manager.users.trond.home.stateVersion = "26.05";

      host.features = {
        bazarr.enable = true;
        caddy.enable = true;
        home-assistant.enable = true;
        lidarr.enable = true;
        mosquitto.enable = true;
        neovim.enable = true;
        nix-dev.enable = true;
        plex.enable = true;
        prowlarr.enable = true;
        qbittorrent.enable = true;
        radarr.enable = true;
        sabnzbd.enable = true;
        seerr.enable = true;
        sonarr.enable = true;
        stylix.enable = true;
        unpackerr.enable = true;
        zigbee2mqtt.enable = true;
      };
    };
}
