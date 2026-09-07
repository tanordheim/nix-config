{
  home-manager.sharedModules = [
    (
      { config, lib, ... }:
      let
        vicinae = lib.getExe config.programs.vicinae.package;
      in
      {
        programs.vicinae = {
          enable = true;
          enableFirefoxIntegration = false;
          systemd = {
            enable = true;
            target = "niri.service";
          };
          settings = {
            pop_to_root_on_close = true;
            favorites = [ "wm:switch-windows" ];
            providers.clipboard.preferences.monitoring = false;
            launcher_window.layer_shell.enabled = true;
            input_server.enabled = false;
            telemetry.system_info = false;
          };
        };

        systemd.user.services.vicinae.Unit.Requisite = [ "niri.service" ];

        wayland.windowManager.niri.settings.binds = {
          "Mod+D" = {
            _props = {
              repeat = false;
              hotkey-overlay-title = "Open Vicinae";
            };
            spawn = [
              vicinae
              "toggle"
            ];
          };
          "Mod+Space" = {
            _props = {
              repeat = false;
              hotkey-overlay-title = "Find an open window";
            };
            spawn = [
              vicinae
              "cmd"
              "launch"
              "wm:switch-windows"
            ];
          };
        };
      }
    )
  ];
}
