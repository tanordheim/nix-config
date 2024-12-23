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
    ./docker.nix
    ./dunst.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./keyboard.nix
    ./linear.nix
    ./obsidian.nix
    ./rofi.nix
    ./slack.nix
    ./users.nix
    ./waybar.nix
  ];

  home-manager.users.${config.username}.home.homeDirectory = "/home/${config.username}";
}
