{
  imports = [
    ../wayland
    ../quickshell
    ./niri.nix
    ./quickshell.nix
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
