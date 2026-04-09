{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./hyprpanel.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprpolkitagent.nix
  ];

  home.packages = with pkgs; [
    libnotify
    xdg-utils
  ];
}
