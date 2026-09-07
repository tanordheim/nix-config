{ pkgs, ... }:
{
  imports = [
    ../wayland
    ../quickshell
    ./hyprland.nix
    ./hypridle.nix
    ../hyprlock
    ./hyprpaper.nix
    ./hyprtoolkit.nix
    ./quickshell.nix
  ];

  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs.hyprland.package = pkgs.hyprland;
  programs.hyprland.portalPackage = pkgs.xdg-desktop-portal-hyprland;

  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.hyprland-qtutils
          pkgs.hyprlauncher
        ];
      }
    )
  ];
}
