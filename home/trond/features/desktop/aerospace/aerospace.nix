{ pkgs, config, ... }:
{
  xdg.configFile = {
    "aerospace/on-workspace-change.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        set -e
        TS=$(date +'%Y-%m-%dT%H:%M:%S')
        echo "$TS notifying sketchybar about workspace change to new workspace '$AEROSPACE_FOCUSED_WORKSPACE'" >> /Users/trond/aerospace-workspace-switch.log
        ${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE >> /Users/trond/aerospace-workspace-switch.log 2>&1
        echo "$TS successfully executed ${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE" >> /Users/trond/aerospace-workspace-switch.log
      '';
    };
  };

  programs.aerospace = {
    enable = true;
    launchd.enable = true;

    settings = {
      after-login-command = [ ];
      after-startup-command = [ ];

      exec-on-workspace-change = [
        "${config.xdg.configHome}/aerospace/on-workspace-change.sh"
      ];

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      accordion-padding = 60;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      automatically-unhide-macos-hidden-apps = true;
      key-mapping.preset = "qwerty";

      gaps = {
        inner = {
          horizontal = 8;
          vertical = 8;
        };
        outer = {
          left = 7;
          bottom = 40;
          top = 7;
          right = 7;
        };
      };

      mode.main.binding = {
        cmd-h = [ ];
        cmd-alt-h = [ ];
        cmd-m = [ ];

        cmd-enter = "exec-and-forget ${pkgs.kitty}/bin/kitty --directory=$HOME";

        ctrl-shift-alt-t = "layout tiles horizontal vertical";
        ctrl-shift-alt-a = "layout accordion horizontal vertical";
        ctrl-shift-alt-f = "layout floating tiling";

        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        ctrl-alt-h = "move left";
        ctrl-alt-j = "move down";
        ctrl-alt-k = "move up";
        ctrl-alt-l = "move right";

        cmd-shift-1 = "workspace 1";
        cmd-shift-keypad1 = "workspace 1";
        cmd-shift-2 = "workspace 2";
        cmd-shift-keypad2 = "workspace 2";
        cmd-shift-3 = "workspace 3";
        cmd-shift-keypad3 = "workspace 3";
        cmd-shift-4 = "workspace 4";
        cmd-shift-keypad4 = "workspace 4";
        cmd-shift-5 = "workspace 5";
        cmd-shift-keypad5 = "workspace 5";
        cmd-shift-6 = "workspace 6";
        cmd-shift-keypad6 = "workspace 6";
        cmd-shift-7 = "workspace 7";
        cmd-shift-keypad7 = "workspace 7";
        cmd-shift-8 = "workspace 8";
        cmd-shift-keypad8 = "workspace 8";
        cmd-shift-9 = "workspace 9";
        cmd-shift-keypad9 = "workspace 9";
        cmd-shift-0 = "workspace 10";
        cmd-shift-keypad0 = "workspace 10";
        cmd-shift-s = "workspace Z";
        cmd-pageDown = "workspace prev";
        cmd-pageUp = "workspace next";
        cmd-home = "workspace-back-and-forth";

        cmd-ctrl-1 = [
          "move-node-to-workspace 1"
          "workspace 1"
        ];
        cmd-ctrl-keypad1 = [
          "move-node-to-workspace 1"
          "workspace 1"
        ];
        cmd-ctrl-2 = [
          "move-node-to-workspace 2"
          "workspace 2"
        ];
        cmd-ctrl-keypad2 = [
          "move-node-to-workspace 2"
          "workspace 2"
        ];
        cmd-ctrl-3 = [
          "move-node-to-workspace 3"
          "workspace 3"
        ];
        cmd-ctrl-keypad3 = [
          "move-node-to-workspace 3"
          "workspace 3"
        ];
        cmd-ctrl-4 = [
          "move-node-to-workspace 4"
          "workspace 4"
        ];
        cmd-ctrl-keypad4 = [
          "move-node-to-workspace 4"
          "workspace 4"
        ];
        cmd-ctrl-5 = [
          "move-node-to-workspace 5"
          "workspace 5"
        ];
        cmd-ctrl-keypad5 = [
          "move-node-to-workspace 5"
          "workspace 5"
        ];
        cmd-ctrl-6 = [
          "move-node-to-workspace 6"
          "workspace 6"
        ];
        cmd-ctrl-keypad6 = [
          "move-node-to-workspace 6"
          "workspace 6"
        ];
        cmd-ctrl-7 = [
          "move-node-to-workspace 7"
          "workspace 7"
        ];
        cmd-ctrl-keypad7 = [
          "move-node-to-workspace 7"
          "workspace 7"
        ];
        cmd-ctrl-8 = [
          "move-node-to-workspace 8"
          "workspace 8"
        ];
        cmd-ctrl-keypad8 = [
          "move-node-to-workspace 8"
          "workspace 8"
        ];
        cmd-ctrl-9 = [
          "move-node-to-workspace 9"
          "workspace 9"
        ];
        cmd-ctrl-keypad9 = [
          "move-node-to-workspace 9"
          "workspace 9"
        ];
        cmd-ctrl-0 = [
          "move-node-to-workspace 10"
          "workspace 10"
        ];
        cmd-ctrl-keypad0 = [
          "move-node-to-workspace 10"
          "workspace 10"
        ];
        cmd-ctrl-s = "move-node-to-workspace Z";
        cmd-ctrl-c = "reload-config";
      };

      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "main";
        "4" = "main";
        "5" = "main";
        "6" = "secondary";
        "7" = "secondary";
        "8" = "secondary";
        "9" = "secondary";
        "10" = "secondary";
        Z = "main";
      };

      on-window-detected = [
        {
          "if".app-id = "com.tinyspeck.slackmacgap";
          run = [ "move-node-to-workspace 6" ];
        }
        {
          "if".app-id = "ru.keepcoder.Telegram";
          run = [ "move-node-to-workspace 6" ];
        }
        {
          "if".app-id = "org.whispersystems.signal-desktop";
          run = [ "move-node-to-workspace 7" ];
        }
        {
          "if".app-id = "net.whatsapp.WhatsApp";
          run = [ "move-node-to-workspace 7" ];
        }
        {
          "if".app-id = "com.hnc.Discord";
          run = [ "move-node-to-workspace 8" ];
        }
        {
          "if".app-id = "com.microsoft.teams2";
          run = [ "move-node-to-workspace 8" ];
        }
        {
          "if".app-id = "com.electron.pocket-casts";
          run = [ "move-node-to-workspace 9" ];
        }
        {
          "if".app-id = "com.spotify.client";
          run = [ "move-node-to-workspace 9" ];
        }
        {
          "if".app-id = "com.obsproject.obs-studio";
          run = [ "move-node-to-workspace 9" ];
        }
        {
          "if".app-id = "com.apple.iphonesimulator";
          run = [ "layout floating" ];
        }
      ];
    };
  };
}
