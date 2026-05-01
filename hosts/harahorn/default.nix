{ pkgs, ... }:
{
  imports = [
    ../../modules/nixos/_base.nix

    ./hardware-configuration.nix

    ../../modules/nixos/hyprland

    ../../modules/common/_1password
    ../../modules/common/chrome
    ../../modules/common/claude
    ../../modules/common/gcp
    ../../modules/common/kitty
    ../../modules/common/neovim
    ../../modules/common/nix-dev

    ../../modules/common/private
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.zpool=z3fold"
    "zswap.max_pool_percent=20"
  ];

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 32 * 1024;
    }
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
  networking.hostName = "harahorn";
  networking.networkmanager.enable = true;

  console.keyMap = "no-latin1";

  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  home-manager.users.trond.home.stateVersion = "26.05";
}
