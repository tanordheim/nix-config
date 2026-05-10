{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      let
        configFormat = pkgs.formats.toml { };
        whisperModel = pkgs.fetchurl {
          url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin";
          hash = "sha256-H8cPd0046xaZk6w5Huo1fvR8iHV+9y7llDh5t+jivGk=";
        };
      in
      {
        home.packages = [ pkgs.voxtype ];

        xdg.configFile."voxtype/config.toml".source = configFormat.generate "voxtype-config.toml" {
          state_file = "auto";

          hotkey = {
            enabled = true;
            key = "F13";
            modifiers = [ ];
            mode = "push_to_talk";
          };

          audio = {
            device = "default";
            sample_rate = 16000;
            max_duration_secs = 60;
            feedback = {
              enabled = true;
              theme = "subtle";
              volume = 0.7;
            };
          };

          whisper = {
            model = "${whisperModel}";
            language = "en";
          };

          output = {
            mode = "type";
            fallback_to_clipboard = true;
            append_text = " ";
            notification = {
              on_recording_start = false;
              on_recording_stop = false;
              on_transcription = false;
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

      }
    )
  ];
}
