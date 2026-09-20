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
        resetWidths = pkgs.writeShellApplication {
          name = "niri-reset-widths";
          runtimeInputs = [
            config.wayland.windowManager.niri.package
            pkgs.libnotify
          ];
          text = ''
            exec ${lib.getExe pkgs.python3} ${./.}/reset-widths.py "$@"
          '';
        };
      in
      {
        wayland.windowManager.niri.settings.binds."Mod+plus" = {
          _props = {
            repeat = false;
            hotkey-overlay-title = "Reset workspace column widths";
          };
          spawn = [
            (lib.getExe resetWidths)
            (toString (100 * config.wayland.windowManager.niri.settings.layout.default-column-width.proportion))
          ];
        };
      }
    )
  ];
}
