{ pkgs, lib, config, ... }:
let
  configHome = "${config.my.user.xdg.configHome}/sketchybar";
  itemDir ="${config.my.user.xdg.configHome}/sketchybar/items";
  pluginDir ="${config.my.user.xdg.configHome}/sketchybar/plugins";

  # TODO: load this from the catppuccin palette, I can't get catppuccin.sources to work
  palette = {
    rosewater = { hex = "f5e0dc"; };
    flamingo = { hex = "f2cdcd"; };
    pink = { hex = "f5c2e7"; };
    mauve = { hex = "cba6f7"; };
    red = { hex = "f38ba8"; };
    maroon = { hex = "eba0ac"; };
    peach = { hex = "fab387"; };
    yellow = { hex = "f9e2af"; };
    green = { hex = "a6e3a1"; };
    teal = { hex = "94e2d5"; };
    sky = { hex = "89dceb"; };
    sapphire = { hex = "74c7ec"; };
    blue = { hex = "89b4fa"; };
    lavender = { hex = "b4befe"; };
    text = { hex = "cdd6f4"; };
    subtext1 = { hex = "bac2de"; };
    subtext0 = { hex = "a6adc8"; };
    overlay2 = { hex = "9399b2"; };
    overlay1 = { hex = "7f849c"; };
    overlay0 = { hex = "6c7086"; };
    surface2 = { hex = "585b70"; };
    surface1 = { hex = "45475a"; };
    surface0 = { hex = "313244"; };
    base = { hex = "1e1e2e"; };
    mantle = { hex = "181825"; };
    crust = { hex = "11111b"; };
  };
  fonts = {
    icon = "Symbols Nerd Font Mono:Bold:14.0";
    label = "JetBrainsMono Nerd Font Mono:Bold:14.0";
    apps = "sketchybar-app-font:Regular:14.0";
  };
  style = {
    height = 28;
    itemCornerRadius = 3;
    itemPadding = 10;
  };

in
{
  config = {
    environment.systemPackages = with pkgs; [
      sketchybar
      sketchybar-app-font
    ];

    fonts.packages = [
      pkgs.sketchybar-app-font
    ];

    launchd.user.agents.sketchybar = {
      serviceConfig = {
        ProgramArguments = [ "${pkgs.sketchybar}/bin/sketchybar" "-c" "${config.my.user.xdg.configHome}/sketchybar/sketchybarrc" ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "${config.my.user.xdg.dataHome}/sketchybar/sketchybar.stdout.log";
        StandardErrorPath = "${config.my.user.xdg.dataHome}/sketchybar/sketchybar.stderr.log";
        EnvironmentVariables = {
          PATH = "${pkgs.sketchybar}/bin:${config.environment.systemPath}";
        };
      };
    };

    my.user.home.shellAliases = {
      restart-sketchybar = ''launchctl kickstart -k gui/"$(id -u)"/org.nixos.sketchybar'';
    };

    my.user.xdg.configFile = {
      "sketchybar/colors-catppuccin.sh" = {
        executable = true;
        text = ''
        '';
      };

      "sketchybar/plugins/aerospace.sh" = {
        executable = true;
        text = ''
        #!/usr/bin/env bash
        BACKGROUND_DRAWING=off
        HIGHLIGHT=false
        if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
          BACKGROUND_DRAWING=on
          HIGHLIGHT=true
        fi
        
        sketchybar --set $NAME \
                         label.highlight=$HIGHLIGHT \
                         background.drawing=$BACKGROUND_DRAWING
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
            "Alacritty")
              icon_result=":alacritty:"
              ;;
            "App Store")
              icon_result=":app_store:"
              ;;
            "Brave Browser")
              icon_result=":brave_browser:"
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
            "System Preferences" | "System Settings")
              icon_result=":gear:"
              ;;
            "GoLand")
              icon_result=":goland:"
              ;;
            "Chromium" | "Google Chrome")
              icon_result=":google_chrome:"
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
            "1Password")
              icon_result=":one_password:"
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

        for m in $(${pkgs.aerospace}/bin/aerospace list-monitors | awk '{print $1}'); do
          for i in $(${pkgs.aerospace}/bin/aerospace list-workspaces --monitor $m); do
            sid=$i
            # skip scratch workspace
            if [ "$sid" == "Z" ]; then
              continue
            fi

            space=(
              space="$sid"
              display=$m
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
            sketchybar --add space space.$sid left \
                       --set space.$sid "''${space[@]}" \
                       --subscribe space.$sid mouse.clicked \
                       --subscribe space.$sid aerospace_workspace_change
          done
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
  };


}
