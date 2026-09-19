{
  imports = [
    ../wayland
    ../quickshell
    ../hyprlock
    ./idle.nix
    ./fill-neighbors.nix
    ./niri.nix
    ./quickshell.nix
    ./vicinae.nix
    ./wallpaper.nix
  ];

  programs.niri = {
    enable = true;
    useNautilus = false;
  };

}
