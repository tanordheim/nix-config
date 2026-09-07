{
  imports = [
    ../wayland
    ../quickshell
    ../hyprlock
    ./idle.nix
    ./layout-presets.nix
    ./niri.nix
    ./quickshell.nix
    ./wallpaper.nix
  ];

  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  home-manager.sharedModules = [
    {
      programs.fuzzel.enable = true;
    }
  ];
}
