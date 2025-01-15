{ pkgs, config, ... }:
{

  home-manager.users.${config.username} =
    { config, ... }:
    let
      inherit (config.lib.formats.rasi) mkLiteral;
      colors = config.lib.stylix.colors;
      theme =
        builtins.toFile "rofi-theme.rasi" # rasi
          ''
            * {
              font: "${config.stylix.fonts.monospace.name} ${toString config.stylix.fonts.sizes.popups}";

              bg0: ${colors.withHashtag.base00};
              bg1: ${colors.withHashtag.base00};
              fg0: ${colors.withHashtag.base05};
              accent-color: ${colors.withHashtag.base0D};
              urgent-color: ${colors.withHashtag.base0A};

              background-color: transparent;
              text-color: @fg0;
              margin: 0;
              padding: 0;
              spacing: 0;
            }

            window {
              location: center;
              width: 600;
              border-color: #78A9FF;
              border: 1;
              background-color: @bg0;
            }

            inputbar {
              spacing: 8px; 
              padding: 8px;
              background-color: @bg1;
            }

            prompt, entry, element-icon, element-text {
              vertical-align: 0.5;
            }

            prompt {
              text-color: @accent-color;
            }

            textbox {
              padding: 8px;
              background-color: @bg1;
            }

            listview {
              padding: 4px 0;
              lines: 8;
              columns: 1;
              fixed-height: false;
            }

            element {
              padding: 8px;
              spacing: 8px;
            }

            element normal normal {
              text-color: @fg0;
            }

            element normal urgent {
              text-color: @urgent-color;
            }

            element normal active {
              text-color: @accent-color;
            }

            element alternate active {
              text-color: @accent-color;
            }

            element selected {
              text-color: @bg0;
            }

            element selected normal, element selected active {
              background-color: @accent-color;
            }

            element selected urgent {
              background-color: @urgent-color;
            }

            element-icon {
              size: 0.8em;
            }

            element-text {
              text-color: inherit;
            }
          '';
    in
    {
      # not working correctly, see https://github.com/danth/stylix/issues/581 - manual styling with stylix colors for now
      stylix.targets.rofi.enable = false;

      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        theme = theme;
        terminal = "${pkgs.wezterm}/bin/wezterm";
        plugins = with pkgs; [
          # see https://github.com/NixOS/nixpkgs/issues/298539, needs some special handling due to ABI incompatibiliby
          (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
        ];
        extraConfig = {
          modes = [
            "drun"
            "calc"
          ];
          show-icons = true;

          # drun
          separator-style = "dash";
          display-drun = "> ";
          drun-display-format = "{icon} {name}";

          # calc
          calc-command = "echo -n '{result}' | wl-copy";
        };
      };
    };
}
