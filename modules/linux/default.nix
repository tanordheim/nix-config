{ config, ... }:
{
  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = "24.11";

  imports = [
    ../common
    ./1password.nix
    ./base-packages.nix
    ./bluetooth.nix
    ./brave.nix
    ./chromium.nix
    ./discord.nix
    ./displaylink.nix
    ./docker.nix
    ./dunst.nix
    ./evince.nix
    ./firefox.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprpolkitagent.nix
    ./keyboard.nix
    ./linear.nix
    ./nixld.nix
    ./obsidian.nix
    ./rofi.nix
    ./shell-aliases.nix
    ./sherlock.nix
    ./slack.nix
    ./stylix.nix
    ./sudo.nix
    ./sysctl.nix
    ./telegram.nix
    ./users.nix
    ./via-udev.nix
    ./waybar.nix
    ./weylus.nix
  ];

  home-manager.users.${config.username} = {
    home.homeDirectory = "/home/${config.username}";
    xdg = {
      enable = true;
      mimeApps.enable = true;
    };
  };
}
