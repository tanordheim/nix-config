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

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
  networking.hostName = "hsrv";
  home-manager.users.trond.home.stateVersion = "24.11";
}
