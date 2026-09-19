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
        layoutPreset = pkgs.writeShellApplication {
          name = "niri-layout-preset";
          runtimeInputs = [
            config.wayland.windowManager.niri.package
            pkgs.jq
            pkgs.libnotify
          ];
          text = builtins.readFile ./layout-presets.sh;
        };
      in
      {
        wayland.windowManager.niri.settings.binds =
          lib.mapAttrs'
            (
              preset: title:
              lib.nameValuePair "Mod+Alt+${preset}" {
                _props = {
                  repeat = false;
                  hotkey-overlay-title = title;
                };
                spawn = [
                  (lib.getExe layoutPreset)
                  preset
                ];
              }
            )
            {
              "1" = "Arrange columns 50/50";
              "2" = "Arrange columns 67/33";
              "3" = "Arrange columns 30/40/30";
            };
      }
    )
  ];
}
