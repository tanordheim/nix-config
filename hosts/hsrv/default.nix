{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    ./hardware-configuration.nix

    ../common/global
    ../common/global/nixos
    ../common/users/trond.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.11";
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

  home-manager.users.trond.home.stateVersion = "25.11";
}
