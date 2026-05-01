{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      let
        configFormat = pkgs.formats.toml { };
        whisperModel = pkgs.fetchurl {
          url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.en.bin";
          hash = "sha256-xhONbVjsyDIgl+D5h8MvG+i7ChhTKj+I9zTRu/nEHl0=";
        };
      in
      {
        home.packages = [ pkgs.voxtype ];

        xdg.configFile."voxtype/config.toml".source = configFormat.generate "voxtype-config.toml" {
          state_file = "auto";

          hotkey = {
            enabled = false;
            key = "SCROLLLOCK";
            modifiers = [ ];
          };

          audio = {
            device = "default";
            sample_rate = 16000;
            max_duration_secs = 60;
          };

          whisper = {
            model = "${whisperModel}";
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
