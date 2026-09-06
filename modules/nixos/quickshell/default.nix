{
  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      let
        startShell = pkgs.writeShellScript "start-quickshell" ''
          case ":$XDG_CURRENT_DESKTOP:" in
            *:Hyprland:*) desktop=hyprland ;;
            *:niri:*) desktop=niri ;;
            *) printf 'Unsupported desktop: %s\n' "$XDG_CURRENT_DESKTOP" >&2; exit 1 ;;
          esac
          exec ${pkgs.quickshell}/bin/quickshell --config "$desktop"
        '';
      in
      {
        programs.quickshell = {
          enable = true;
          package = pkgs.quickshell;
        };

        systemd.user.services.quickshell = {
          Unit = {
            Description = "quickshell";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
            ConditionEnvironment = "WAYLAND_DISPLAY";
            StartLimitIntervalSec = 60;
            StartLimitBurst = 5;
            X-Restart-Triggers = builtins.attrValues config.programs.quickshell.configs;
          };
          Service = {
            ExecStart = "${startShell}";
            Slice = "session.slice";
            Restart = "on-failure";
            RestartSec = 2;
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      }
    )
  ];
}
