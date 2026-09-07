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
        lockSession = pkgs.writeShellApplication {
          name = "lock-niri-session";
          runtimeInputs = [
            pkgs.bash
            pkgs.coreutils
            pkgs.systemd
          ];
          text = ''
            : "''${XDG_SESSION_ID:?Missing graphical session ID}"
            systemctl --user start niri-lock.service
            timeout 5s bash -eu <<'EOF'
            while true; do
              locked=$(loginctl show-session "$XDG_SESSION_ID" --property=LockedHint --value)
              if [ "$locked" = yes ]; then
                exit 0
              fi
              sleep 0.05
            done
            EOF
          '';
        };
        lockCommand = lib.getExe lockSession;
        powerOn = "${lib.getExe config.wayland.windowManager.niri.package} msg action power-on-monitors";
      in
      {
        wayland.windowManager.niri.settings.binds."Mod+Alt+L" = {
          _props = {
            repeat = false;
            hotkey-overlay-title = "Lock session";
          };
          spawn = [ lockCommand ];
        };

        systemd.user.services.niri-lock = {
          Unit = {
            Description = "Lock the Niri session";
            PartOf = [ "niri.service" ];
            After = [ "niri.service" ];
            Requisite = [ "niri.service" ];
          };
          Service = {
            Type = "exec";
            ExecStart = "${lib.getExe config.programs.hyprlock.package} --immediate-render";
            Slice = "session.slice";
          };
        };

        services.swayidle = {
          enable = true;
          systemdTargets = [ "niri.service" ];
          extraArgs = [ "-w" ];
          events = {
            lock = lockCommand;
            before-sleep = lockCommand;
            after-resume = powerOn;
          };
          timeouts = [
            {
              timeout = 1800;
              command = lockCommand;
            }
            {
              timeout = 2100;
              command = "${lib.getExe config.wayland.windowManager.niri.package} msg action power-off-monitors";
              resumeCommand = powerOn;
            }
          ];
        };
      }
    )
  ];
}
