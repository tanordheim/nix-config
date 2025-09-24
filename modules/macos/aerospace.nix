{
  nix-homebrew,
  homebrew-aerospace,
  config,
  pkgs,
  ...
}:
let
  toTOML = (pkgs.formats.toml { }).generate;

in
{
  nix-homebrew = {
    taps = {
      "nikitabobko/homebrew-tap" = homebrew-aerospace;
    };
  };

  homebrew.casks = [
    "aerospace"
  ];

  environment.systemPackages = with pkgs; [
    jankyborders
  ];

  home-manager.users.${config.username} =
    { lib, config, ... }:
    let
      colors = config.lib.stylix.colors;
    in
    {
      home.activation.aerospaceConfig =
        lib.hm.dag.entryAfter [ "writeBoundary" ] # bash
          ''
            $VERBOSE_ECHO "Reloading configuration"
            $DRY_RUN_CMD ${pkgs.aerospace}/bin/aerospace reload-config
          '';

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

        "aerospace/aerospace.toml".source = toTOML "aerospace.toml" {
          # You can use it to add commands that run after login to macOS user session.
          # 'start-at-login' needs to be 'true' for 'after-login-command' to work
          # Available commands: https://nikitabobko.github.io/AeroSpace/commands
          after-login-command = [ ];

          # You can use it to add commands that run after AeroSpace startup.
          # 'after-startup-command' is run after 'after-login-command'
          # Available commands : https://nikitabobko.github.io/AeroSpace/commands
          after-startup-command = [
            "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=0xff${colors.base0D} inactive_color=0xff${colors.base03} width=5.0"
          ];

          # Start AeroSpace at login
          start-at-login = true;

          # Notify sketchybar on workspace change
          exec-on-workspace-change = [
            "${config.xdg.configHome}/aerospace/on-workspace-change.sh"
          ];

          # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;

          # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
          # The 'accordion-padding' specifies the size of accordion padding
          # You can set 0 to disable the padding feature
          accordion-padding = 60;

          # Possible values: tiles|accordion
          default-root-container-layout = "tiles";

          # Possible values: horizontal|vertical|auto
          # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
          #               tall monitor (anything higher than wide) gets vertical orientation
          default-root-container-orientation = "auto";

          # Mouse follows focus when focused monitor changes
          # Drop it from your config, if you don't like this behavior
          # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
          # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
          # Fallback value (if you omit the key): on-focused-monitor-changed = []
          on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

          # You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
          # Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key
          # Also see: https://nikitabobko.github.io/AeroSpace/goodies#disable-hide-app
          automatically-unhide-macos-hidden-apps = true;

          # Possible values: (qwerty|dvorak)
          # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
          key-mapping.preset = "qwerty";

          # Gaps between windows (inner-*) and between monitor edges (outer-*).
          # Possible values:
          # - Constant:     gaps.outer.top = 8
          # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
          #                 In this example, 24 is a default value when there is no match.
          #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
          #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
          gaps = {
            inner.horizontal = 8;
            inner.vertical = 8;
            outer.left = 7;
            outer.bottom = 40;
            outer.top = 7;
            outer.right = 7;
          };

          # 'main' binding mode declaration
          # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
          # 'main' binding mode must be always presented
          # Fallback value (if you omit the key): mode.main.binding = {}
          mode.main.binding = {
            # All possible keys:
            # - Letters.        a, b, c, ..., z
            # - Numbers.        0, 1, 2, ..., 9
            # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
            # - F-keys.         f1, f2, ..., f20
            # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
            #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
            # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
            #                   keypadMinus, keypadMultiply, keypadPlus
            # - Arrows.         left, down, up, right

            # All possible modifiers: cmd, alt, ctrl, shift

            # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

            # Disable annoying "hide application" shortcuts
            cmd-h = [ ];
            cmd-alt-h = [ ];
            cmd-m = [ ];

            # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
            cmd-enter = "exec-and-forget ${pkgs.wezterm}/bin/wezterm";
            alt-ctrl-s = "exec-and-forget screencapture -i -c";

            # See: https://nikitabobko.github.io/AeroSpace/commands#layout
            ctrl-shift-alt-t = "layout tiles horizontal vertical";
            ctrl-shift-alt-a = "layout accordion horizontal vertical";
            ctrl-shift-alt-f = "layout floating tiling";

            # See: https://nikitabobko.github.io/AeroSpace/commands#focus
            alt-m = "focus left";
            alt-n = "focus down";
            alt-e = "focus up";
            alt-i = "focus right";

            # See: https://nikitabobko.github.io/AeroSpace/commands#move
            ctrl-alt-m = "move left";
            ctrl-alt-n = "move down";
            ctrl-alt-e = "move up";
            ctrl-alt-i = "move right";

            # See: https://nikitabobko.github.io/AeroSpace/commands#resize
            # ctrl-shift-alt-comma = "resize smart -50";
            # ctrl-shift-alt-period = "resize smart +50";

            # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
            cmd-ctrl-keypad1 = "workspace 1";
            cmd-ctrl-keypad2 = "workspace 2";
            cmd-ctrl-keypad3 = "workspace 3";
            cmd-ctrl-keypad4 = "workspace 4";
            cmd-ctrl-keypad5 = "workspace 5";
            cmd-ctrl-keypad6 = "workspace 6";
            cmd-ctrl-keypad7 = "workspace 7";
            cmd-ctrl-keypad8 = "workspace 8";
            cmd-ctrl-keypad9 = "workspace 9";
            cmd-ctrl-keypad0 = "workspace 10";
            cmd-ctrl-s = "workspace Z";
            cmd-pageDown = "workspace prev";
            cmd-pageUp = "workspace next";
            cmd-home = "workspace-back-and-forth";

            # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
            cmd-shift-keypad1 = [
              "move-node-to-workspace 1"
              "workspace 1"
            ];
            cmd-shift-keypad2 = [
              "move-node-to-workspace 2"
              "workspace 2"
            ];
            cmd-shift-keypad3 = [
              "move-node-to-workspace 3"
              "workspace 3"
            ];
            cmd-shift-keypad4 = [
              "move-node-to-workspace 4"
              "workspace 4"
            ];
            cmd-shift-keypad5 = [
              "move-node-to-workspace 5"
              "workspace 5"
            ];
            cmd-shift-keypad6 = [
              "move-node-to-workspace 6"
              "workspace 6"
            ];
            cmd-shift-keypad7 = [
              "move-node-to-workspace 7"
              "workspace 7"
            ];
            cmd-shift-keypad8 = [
              "move-node-to-workspace 8"
              "workspace 8"
            ];
            cmd-shift-keypad9 = [
              "move-node-to-workspace 9"
              "workspace 9"
            ];
            cmd-shift-keypad0 = [
              "move-node-to-workspace 10"
              "workspace 10"
            ];
            cmd-shift-s = "move-node-to-workspace Z";
            cmd-shift-c = "reload-config";
          };

          # See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
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

          # Assign windows to workspaces
          # See: https://nikitabobko.github.io/AeroSpace/guide#callbacks
          on-window-detected = [
            {
              "if".app-id = "com.tinyspeck.slackmacgap";
              run = [ "move-node-to-workspace 6" ];
            }
            {
              "if".app-id = "com.tdesktop.Telegram";
              run = [ "move-node-to-workspace 6" ];
            }
            {
              "if".app-id = "org.whispersystems.signal-desktop";
              run = [ "move-node-to-workspace 7" ];
            }
            {
              "if".app-id = "com.hnc.Discord";
              run = [ "move-node-to-workspace 7" ];
            }
            {
              "if".app-id = "com.linear";
              run = [ "move-node-to-workspace 9" ];
            }
            {
              "if".app-id = "com.amazonaws.acvc.osx";
              run = [
                "layout floating"
                "move-node-to-workspace Z"
              ];
            }
          ];
        };
      };
    };
}
