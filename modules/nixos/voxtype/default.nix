{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      let
        configFormat = pkgs.formats.toml { };
      in
      {
        home.packages = [ pkgs.voxtype ];

        xdg.configFile."voxtype/config.toml".source = configFormat.generate "voxtype-config.toml" {
          state_file = "auto";

          whisper = {
            model = "small.en";
            language = "en";
          };

          output = {
            mode = "type";
            fallback_to_clipboard = true;
            notification = {
              on_recording_start = true;
              on_transcription = true;
            };
          };

          status.icon_theme = "nerd-font";
        };

        systemd.user.services.voxtype = {
          Unit = {
            Description = "Voxtype dictation daemon";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${pkgs.voxtype}/bin/voxtype daemon";
            Restart = "on-failure";
            RestartSec = 3;
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };

        wayland.windowManager.hyprland.settings.bind = [
          "$mainMod CTRL, D, exec, ${pkgs.voxtype}/bin/voxtype record toggle"
        ];
      }
    )
  ];
}
