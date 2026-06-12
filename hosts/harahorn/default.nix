{ pkgs, ... }:
{
  imports = [
    ../../modules/nixos/_base.nix

    ./hardware-configuration.nix
    ./sops.nix
    ./backups.nix

    ../../modules/nixos/houdini
    ../../modules/nixos/hyprland
    ../../modules/nixos/printing
    ../../modules/nixos/voxtype

    ../../modules/common/_1password
    ../../modules/common/android-studio
    ../../modules/common/atuin
    ../../modules/common/chrome
    ../../modules/common/claude
    ../../modules/common/discord
    ../../modules/common/docker
    ../../modules/common/firefox
    ../../modules/common/gaming
    ../../modules/common/gdrive
    ../../modules/common/ghostty
    ../../modules/common/jetbrains
    ../../modules/common/kitty
    ../../modules/common/linear
    ../../modules/common/maestro
    ../../modules/common/neovim
    ../../modules/common/obsidian
    ../../modules/common/plex-client
    ../../modules/common/pocketcasts
    ../../modules/common/qmk
    ../../modules/common/signal
    ../../modules/common/slack
    ../../modules/common/spotify
    ../../modules/common/syncthing
    ../../modules/common/teams
    ../../modules/common/telegram
    ../../modules/common/tmux
    ../../modules/common/vscode
    ../../modules/common/whatsapp

    ../../modules/common/postgres
    ../../modules/common/redis
    ../../modules/common/kaf
    ../../modules/common/stern

    ../../modules/common/aws
    ../../modules/common/azure
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
    "pcie_aspm.policy=performance"
    "pcie_port_pm=off"
    "pcie_ports=native"
  ];
  boot.kernelModules = [ "nct6775" ];

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
  networking.networkmanager.unmanaged = [ "wlp8s0" ];

  console.keyMap = "no-latin1";

  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.systemPackages = [
    pkgs.cameractrls
    pkgs.v4l-utils
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="video4linux", ACTION=="add", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="085e", ENV{ID_V4L_CAPABILITIES}=="*:capture:*", TAG+="systemd", ENV{SYSTEMD_WANTS}+="brio-apply@%k.service"
  '';

  systemd.services."brio-apply@" = {
    description = "Apply Logitech Brio settings to %i";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.cameractrls}/bin/cameractrls -d /dev/%i -c logitech_brio_fov=65,zoom_absolute=100,pan_absolute=0,tilt_absolute=0";
    };
  };

  home-manager.users.trond.home.stateVersion = "26.05";
}
