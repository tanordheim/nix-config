{ pkgs, ... }:
{
  imports = [
    ../../modules/nixos/_base.nix

    ./hardware-configuration.nix

    ../../modules/nixos/hyprland
    ../../modules/nixos/voxtype

    ../../modules/common/_1password
    ../../modules/common/android-studio
    ../../modules/common/atuin
    ../../modules/common/chrome
    ../../modules/common/claude
    ../../modules/common/discord
    ../../modules/common/docker
    ../../modules/common/firefox
    ../../modules/common/gdrive
    ../../modules/common/jetbrains
    ../../modules/common/kitty
    ../../modules/common/neovim
    ../../modules/common/obsidian
    ../../modules/common/pocketcasts
    ../../modules/common/qmk
    ../../modules/common/signal
    ../../modules/common/slack
    ../../modules/common/spotify
    ../../modules/common/syncthing
    ../../modules/common/teams
    ../../modules/common/telegram
    ../../modules/common/vscode
    ../../modules/common/whatsapp

    ../../modules/common/postgres
    ../../modules/common/redis
    ../../modules/common/kaf
    ../../modules/common/stern

    ../../modules/common/aws
    ../../modules/common/gcp
    ../../modules/common/kubernetes

    ../../modules/common/dotnet-dev
    ../../modules/common/go-dev
    ../../modules/common/html-dev
    ../../modules/common/java-dev
    ../../modules/common/kotlin-dev
    ../../modules/common/nix-dev
    ../../modules/common/node-dev
    ../../modules/common/protobuf-dev
    ../../modules/common/python-dev
    ../../modules/common/rust-dev
    ../../modules/common/terraform-dev

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
