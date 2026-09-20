{
  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        fillNeighbors = pkgs.writeShellApplication {
          name = "niri-fill-neighbors";
          runtimeInputs = [
            config.wayland.windowManager.niri.package
            pkgs.libnotify
          ];
          text = ''
            exec ${lib.getExe pkgs.python3} ${./.}/fill-neighbors.py "$@"
          '';
        };
      in
      {
        wayland.windowManager.niri.settings.binds."Mod+Shift+F" = {
          _props = {
            repeat = false;
            hotkey-overlay-title = "Fill space beside focused column";
          };
          spawn = [
            (lib.getExe fillNeighbors)
            (toString config.wayland.windowManager.niri.settings.layout.gaps)
          ];
        };
      }
    )
  ];
}
