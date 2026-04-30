{
  imports = [
    ../../modules/nixos/_base.nix

    ./hardware-configuration.nix
    ./sops.nix
    ./arr-download-clients.nix
    ./backups.nix

    ../../modules/common/neovim
    ../../modules/common/nix-dev

    ../../modules/nixos/atuin-server
    ../../modules/nixos/aurral
    ../../modules/nixos/bazarr
    ../../modules/nixos/caddy
    ../../modules/nixos/home-assistant
    ../../modules/nixos/lidarr
    ../../modules/nixos/mosquitto
    ../../modules/nixos/plex
    ../../modules/nixos/prowlarr
    ../../modules/nixos/qbittorrent
    ../../modules/nixos/radarr
    ../../modules/nixos/sabnzbd
    ../../modules/nixos/seerr
    ../../modules/nixos/sonarr
    ../../modules/nixos/unpackerr
    ../../modules/nixos/zigbee2mqtt
  ];

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
}
