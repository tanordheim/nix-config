{
  imports = [
    ../../modules/_new/nixos/_base.nix

    ./hardware-configuration.nix
    ./sops.nix
    ./arr-download-clients.nix
    ./backups.nix

    ../../modules/_new/common/neovim
    ../../modules/_new/common/nix-dev

    ../../modules/_new/nixos/atuin-server
    ../../modules/_new/nixos/aurral
    ../../modules/_new/nixos/bazarr
    ../../modules/_new/nixos/caddy
    ../../modules/_new/nixos/home-assistant
    ../../modules/_new/nixos/lidarr
    ../../modules/_new/nixos/mosquitto
    ../../modules/_new/nixos/plex
    ../../modules/_new/nixos/prowlarr
    ../../modules/_new/nixos/qbittorrent
    ../../modules/_new/nixos/radarr
    ../../modules/_new/nixos/sabnzbd
    ../../modules/_new/nixos/seerr
    ../../modules/_new/nixos/sonarr
    ../../modules/_new/nixos/unpackerr
    ../../modules/_new/nixos/zigbee2mqtt
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
