{
  home-manager.sharedModules = [
    (
      {
        lib,
        config,
        pkgs,
        ...
      }:
      let
        configHome = "/Users/trond/.config/sketchybar";
        itemDir = "/Users/trond/.config/sketchybar/items";
        pluginDir = "/Users/trond/.config/sketchybar/plugins";

        palette = {
          rosewater.hex = "f5e0dc";
          flamingo.hex = "f2cdcd";
          pink.hex = "f5c2e7";
          mauve.hex = "cba6f7";
          red.hex = "f38ba8";
          maroon.hex = "eba0ac";
          peach.hex = "fab387";
          yellow.hex = "f9e2af";
          green.hex = "a6e3a1";
          teal.hex = "94e2d5";
          sky.hex = "89dceb";
          sapphire.hex = "74c7ec";
          blue.hex = "89b4fa";
          lavender.hex = "b4befe";
          text.hex = "cdd6f4";
          subtext1.hex = "bac2de";
          subtext0.hex = "a6adc8";
          overlay2.hex = "9399b2";
          overlay1.hex = "7f849c";
          overlay0.hex = "6c7086";
          surface2.hex = "585b70";
          surface1.hex = "45475a";
          surface0.hex = "313244";
          base.hex = "1e1e2e";
          mantle.hex = "181825";
          crust.hex = "11111b";
        };
        fonts = {
          icon = "Symbols Nerd Font Mono:Bold:14.0";
          label = "Aporetic Sans Mono:Bold:14.0";
          apps = "sketchybar-app-font:Regular:14.0";
        };
        style = {
          height = 28;
          itemCornerRadius = 3;
          itemPadding = 10;
        };
      in
      {
        home.packages = with pkgs; [
          sketchybar
          sketchybar-app-font
        ];

        home.shellAliases = {
          restart-sketchybar = ''launchctl kickstart -k gui/"$(id -u)"/org.nix-community.home.sketchybar'';
        };

        services.macos-remap-keys = {
          enable = true;
          keyboard = {
            Capslock = "Escape";
          };
        };

        launchd.agents.sketchybar = {
          enable = true;
          config = {
            ProgramArguments = [
              "${pkgs.sketchybar}/bin/sketchybar"
              "-c"
              "/Users/trond/.config/sketchybar/sketchybarrc"
            ];
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/Users/trond/.local/share/sketchybar/sketchybar.stdout.log";
            StandardErrorPath = "/Users/trond/.local/share/sketchybar/sketchybar.stderr.log";
            EnvironmentVariables = {
              PATH = "${pkgs.sketchybar}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
            };
          };
        };

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

          "sketchybar/plugins/aerospace.sh" = {
            executable = true;
            text = ''
              #!/usr/bin/env bash
              set -e
              TS=$(date +'%Y-%m-%dT%H:%M:%S')
              echo "$TS triggering aerospace workspace switch - arg is '$1', NAME is '$NAME', FOCUSED_WORKSPACE is '$FOCUSED_WORKSPACE'" >> /Users/trond/sketchybar-workspace-switch.log
              BACKGROUND_DRAWING=off
              HIGHLIGHT=false
              if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
                BACKGROUND_DRAWING=on
                HIGHLIGHT=true
              fi
              echo "$TS determined BACKGROUND_DRAWING to be '$BACKGROUND_DRAWING' and HIGHLIGHT to be '$HIGHLIGHT'" >> /Users/trond/sketchybar-workspace-switch.log

              sketchybar --set $NAME \
                               label.highlight=$HIGHLIGHT \
                               background.drawing=$BACKGROUND_DRAWING
              echo "$TS successfully executed sketchybar --set $NAME label.highlight=$HIGHLIGHT background.drawing=$BACKGROUND_DRAWING" >> /Users/trond/sketchybar-workspace-switch.log
            '';
          };

          "sketchybar/plugins/front-app.sh" = {
            executable = true;
            text = ''
              #!/usr/bin/env bash
              icon=$(${pluginDir}/icon-map.sh "$INFO")
              sketchybar --set "$NAME" label="$INFO" icon="$icon"
            '';
          };

          "sketchybar/plugins/icon-map.sh" = {
            executable = true;
            text = ''
              #!/usr/bin/env bash
              function __icon_map() {
                case "$1" in
                  "1Password")
                    icon_result=":one_password:"
                    ;;
                  "App Store")
                    icon_result=":app_store:"
                    ;;
                  "Brave Browser")
                    icon_result=":brave_browser:"
                    ;;
                  "Chromium" | "Google Chrome")
                    icon_result=":google_chrome:"
                    ;;
                  "Code" | "Code - Insiders")
                    icon_result=":code:"
                    ;;
                  "DataGrip")
                    icon_result=":datagrip:"
                    ;;
                  "Discord")
                    icon_result=":discord:"
                    ;;
                  "Finder")
                    icon_result=":finder:"
                    ;;
                  "Firefox")
                    icon_result=":firefox:"
                    ;;
                  "GoLand")
                    icon_result=":goland:"
                    ;;
                  "kitty")
                    icon_result=":kitty:"
                    ;;
                  "Linear")
                    icon_result=":linear:"
                    ;;
                  "Miro")
                    icon_result=":miro:"
                    ;;
                  "Neovide" | "neovide")
                    icon_result=":neovide:"
                    ;;
                  "Neovim" | "neovim" | "nvim")
                    icon_result=":neovim:"
                    ;;
                  "Obsidian")
                    icon_result=":obsidian:"
                    ;;
                  "Rider" | "JetBrains Rider")
                    icon_result=":rider:"
                    ;;
                  "Safari")
                    icon_result=":safari:"
                    ;;
                  "Signal")
                    icon_result=":signal:"
                    ;;
                  "Slack")
                    icon_result=":slack:"
                    ;;
                  "Spotify")
                    icon_result=":spotify:"
                    ;;
                  "Spotlight")
                    icon_result=":spotlight:"
                    ;;
                  "System Preferences" | "System Settings")
                    icon_result=":gear:"
                    ;;
                  "Telegram")
                    icon_result=":telegram:"
                    ;;
                  "Terminal")
                    icon_result=":terminal:"
                    ;;
                  "WebStorm")
                    icon_result=":web_storm:"
                    ;;
                  "Xcode")
                    icon_result=":xcode:"
                    ;;
                  *)
                    icon_result=":default:"
                    ;;
                  esac
              }

              __icon_map "$1"
              echo "$icon_result"
            '';
          };

          "sketchybar/items/aerospace-workspaces.sh" = {
            executable = true;
            text = ''
              #!/usr/bin/env bash

              # Add event that aerospace can trigger when workspaces change
              sketchybar --add event aerospace_workspace_change

              # Paddings on brackets does not work, add a fake element at the start to get some padding
              # See https://github.com/FelixKratz/SketchyBar/issues/639
              space_padding=(
                label=""
                label.padding_left=${toString style.itemPadding}
              )
              sketchybar --add item space.padding_left left \
                         --set space.padding_left "''${space_padding[@]}"

              # aerospace server may not be ready yet when sketchybar launches
              # at login; retry until list-workspaces returns something.
              workspaces=""
              for _ in $(seq 1 30); do
                workspaces=$(${pkgs.aerospace}/bin/aerospace list-workspaces --all 2>/dev/null || true)
                if [ -n "$workspaces" ]; then
                  break
                fi
                sleep 1
              done

              for i in $workspaces; do
                sid=$i
                # skip scratch workspace
                if [ "$sid" == "Z" ]; then
                  continue
                fi

                space=(
                  label.padding_left=10
                  label.padding_right=10
                  label="$sid"
                  label.color=0xff${palette.text.hex}
                  label.highlight_color=0xff${palette.surface0.hex}
                  label.y_offset=1
                  background.color=0xff${palette.subtext0.hex}
                  background.drawing=off
                  click_script="${pkgs.aerospace}/bin/aerospace workspace $sid"
                  script="${pluginDir}/aerospace.sh $sid"
                )
                sketchybar --add item space.$sid left \
                           --set space.$sid "''${space[@]}" \
                           --subscribe space.$sid mouse.clicked \
                           --subscribe space.$sid aerospace_workspace_change
              done

              sketchybar --add item space.padding_right left \
                         --set space.padding_right "''${space_padding[@]}"

              spaces_bracket=(
                background.color=0xff${palette.base.hex}
                background.height=${toString style.height}
              )
              sketchybar --add bracket spaces_bracket '/space\..*/'  \
                         --set spaces_bracket "''${spaces_bracket[@]}"
            '';
          };

          "sketchybar/items/clock.sh" = {
            executable = true;
            text = ''
              #!/usr/bin/env bash
              clock=(
                update_freq=10
                label.padding_left=${toString style.itemPadding}
                label.padding_right=${toString style.itemPadding}
                background.color=0xff${palette.base.hex}
                script="${pluginDir}/clock.sh"
              )
              sketchybar --add item clock right \
                         --set clock "''${clock[@]}"
            '';
          };

          "sketchybar/plugins/clock.sh" = {
            executable = true;
            text = ''
              #!/usr/bin/env bash
              sketchybar --set "$NAME" label="$(date '+%a %b %d, %H:%M')"
            '';
          };

          "sketchybar/items/front-app.sh" = {
            executable = true;
            text = ''
              #!/usr/bin/env bash
              front_app=(
                display=active
                icon.font="${fonts.apps}"
                icon.color=0xff${palette.lavender.hex}
                icon.padding_left=${toString style.itemPadding}
                icon.padding_right=${toString style.itemPadding}
                icon.y_offset=-1
                label.padding_left=0
                label.padding_right=${toString style.itemPadding}
                background.color=0xff${palette.base.hex}
                script="${pluginDir}/front-app.sh"
              )
              sketchybar --add item front_app center \
                         --set front_app "''${front_app[@]}" \
                         --subscribe front_app front_app_switched
            '';
          };

          "sketchybar/sketchybarrc" = {
            executable = true;
            text = ''
              #!/usr/bin/env bash

              # Create bar
              sketchybar --bar \
                         color=0x00000000 \
                         height=${toString style.height} \
                         position=bottom \
                         margin=0 \
                         corner_radius=0 \
                         padding_left=10 \
                         padding_right=10

              # Set bar defaults
              sketchybar --default \
                         icon.font="${fonts.icon}" \
                         label.font="${fonts.label}" \
                         background.height=${toString style.height} \
                         background.corner_radius=${toString style.itemCornerRadius}

              # Load all items
              source "${itemDir}/aerospace-workspaces.sh"
              source "${itemDir}/front-app.sh"
              source "${itemDir}/clock.sh"

              # Force all scripts to run
              sketchybar --update
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
    )
  ];
}
