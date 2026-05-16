{
  home-manager.sharedModules = [
    (
      { pkgs, lib, config, ... }:
      let
        colors = config.lib.stylix.colors;
        inline = lib.generators.mkLuaInline;
        bind = keys: dispatcher: { _args = [ keys (inline dispatcher) ]; };
        bindMouse = keys: dispatcher: { _args = [ keys (inline dispatcher) { mouse = true; } ]; };
      in
      {
        stylix.targets.hyprland.enable = false;

        wayland.windowManager.hyprland = {
          enable = true;
          package = pkgs.bleeding.hyprland;
          portalPackage = pkgs.bleeding.xdg-desktop-portal-hyprland;
          settings = {
            config = {
              general = {
                gaps_in = 10;
                gaps_out = 15;
                border_size = 2;
                layout = "master";
                allow_tearing = false;
                "col.active_border" = "rgb(${colors.base0D})";
                "col.inactive_border" = "rgb(${colors.base03})";
              };

              decoration = {
                active_opacity = 1;
                fullscreen_opacity = 1;
                inactive_opacity = 1;
                dim_inactive = false;
                dim_strength = 0.2;
                rounding = 5;
                blur = {
                  enabled = true;
                  size = 2;
                  passes = 2;
                  vibrancy = 0.1000;
                  ignore_opacity = true;
                  new_optimizations = true;
                };
                shadow = {
                  enabled = true;
                  range = 4;
                  render_power = 3;
                  color = "rgba(${colors.base00}99)";
                };
              };

              animations.enabled = true;

              dwindle = {
                preserve_split = true;
              };

              master.new_status = "slave";

              render = {
                direct_scanout = 0;
                cm_enabled = false;
              };

              misc = {
                force_default_wallpaper = 0;
                disable_hyprland_logo = true;
                animate_manual_resizes = true;
                mouse_move_enables_dpms = true;
                key_press_enables_dpms = true;
                middle_click_paste = false;
                vrr = 0;
                background_color = "rgb(${colors.base00})";
              };

              group = {
                "col.border_active" = "rgb(${colors.base0D})";
                "col.border_inactive" = "rgb(${colors.base03})";
                "col.border_locked_active" = "rgb(${colors.base0C})";
                groupbar = {
                  "col.active" = "rgb(${colors.base0D})";
                  "col.inactive" = "rgb(${colors.base03})";
                  "text_color" = "rgb(${colors.base05})";
                };
              };

              input = {
                kb_layout = "no";
                kb_variant = "nodeadkeys";
                float_switch_override_focus = false;
                numlock_by_default = true;
                repeat_rate = 50;
                repeat_delay = 250;
                follow_mouse = false;
                sensitivity = 0;
              };
            };

            animation = [
              { _args = [ { leaf = "windows";    enabled = true; speed = 2;  bezier = "default"; style = "popin"; } ]; }
              { _args = [ { leaf = "windowsOut"; enabled = true; speed = 2;  bezier = "default"; style = "popin"; } ]; }
              { _args = [ { leaf = "border";     enabled = true; speed = 10; bezier = "default"; } ]; }
              { _args = [ { leaf = "fade";       enabled = true; speed = 5;  bezier = "default"; } ]; }
              { _args = [ { leaf = "workspaces"; enabled = true; speed = 2;  bezier = "default"; } ]; }
            ];

            env = [
              { _args = [ "QT_QPA_PLATFORMTHEME" "qt5ct" ]; }
              { _args = [ "GSK_RENDERER" "gl" ]; }
            ];

            monitor = [
              { _args = [ { output = "DP-1"; mode = "2560x1440@155"; position = "0x0";      scale = 1; transform = 1; } ]; }
              { _args = [ { output = "DP-2"; mode = "3440x1440@180"; position = "1440x320"; scale = 1; } ]; }
            ];

            workspace_rule = [
              { _args = [ { workspace = "1";  monitor = "DP-2"; default = true; } ]; }
              { _args = [ { workspace = "2";  monitor = "DP-2"; } ]; }
              { _args = [ { workspace = "3";  monitor = "DP-2"; } ]; }
              { _args = [ { workspace = "4";  monitor = "DP-2"; } ]; }
              { _args = [ { workspace = "5";  monitor = "DP-2"; } ]; }
              { _args = [ { workspace = "6";  monitor = "DP-1"; default = true; layout_opts = { orientation = "top"; }; } ]; }
              { _args = [ { workspace = "7";  monitor = "DP-1"; layout_opts = { orientation = "top"; }; } ]; }
              { _args = [ { workspace = "8";  monitor = "DP-1"; layout_opts = { orientation = "top"; }; } ]; }
              { _args = [ { workspace = "9";  monitor = "DP-1"; layout_opts = { orientation = "top"; }; } ]; }
              { _args = [ { workspace = "10"; monitor = "DP-1"; layout_opts = { orientation = "top"; }; } ]; }
            ];

            window_rule = [
              { _args = [ { name = "slack-ws6";       match = { class = "^(Slack)$"; };                                                       workspace = "6 silent"; } ]; }
              { _args = [ { name = "telegram-ws6";    match = { class = "^(org\\.telegram\\.desktop)$"; };                                    workspace = "6 silent"; } ]; }
              { _args = [ { name = "signal-ws7";      match = { class = "^(signal)$"; };                                                      workspace = "7 silent"; } ]; }
              { _args = [ { name = "whatsapp-ws7";    match = { class = "^(electron)$"; title = "^(WhatsApp Electron .*)$"; };                workspace = "7 silent"; } ]; }
              { _args = [ { name = "teams-ws8";       match = { class = "^(electron)$"; title = "^(.*Microsoft Teams)$"; };                   workspace = "8 silent"; } ]; }
              { _args = [ { name = "spotify-ws9";     match = { class = "^(spotify)$"; };                                                     workspace = "9 silent"; } ]; }
              { _args = [ { name = "pocketcasts-ws9"; match = { class = "^(Electron)$"; title = "^(.*Pocket Casts)$"; };                      workspace = "9 silent"; } ]; }
              { _args = [ { name = "discord-ws8";     match = { class = "^(discord)$"; };                                                     workspace = "8 silent"; } ]; }
              { _args = [ { name = "tsm-magic";       match = { title = "^(TradeSkillMaster Application.*)$"; };                              workspace = "special:magic silent"; } ]; }
              { _args = [ { name = "explorer-hidden"; match = { class = "^(explorer\\.exe)$"; title = "^$"; };                                workspace = "special:hidden silent"; } ]; }
            ];

            bind = [
              (bind "ALT + return"            ''hl.dsp.exec_cmd("${pkgs.ghostty}/bin/ghostty --working-directory=$HOME")'')
              (bind "ALT + space"             ''hl.dsp.exec_cmd("${pkgs.bleeding.hyprlauncher}/bin/hyprlauncher")'')
              (bind "ALT + SHIFT + W"          "hl.dsp.window.close()")
              (bind "ALT + CTRL + SUPER + BackSpace" "hl.dsp.exit()")
              (bind "ALT + CTRL + C"          ''hl.dsp.exec_cmd("hyprctl reload")'')

              (bind "SUPER + h" ''hl.dsp.focus({ direction = "left" })'')
              (bind "SUPER + j" ''hl.dsp.focus({ direction = "down" })'')
              (bind "SUPER + k" ''hl.dsp.focus({ direction = "up" })'')
              (bind "SUPER + l" ''hl.dsp.focus({ direction = "right" })'')

              (bind "CTRL + SUPER + h" ''hl.dsp.window.move({ direction = "left" })'')
              (bind "CTRL + SUPER + j" ''hl.dsp.window.move({ direction = "down" })'')
              (bind "CTRL + SUPER + k" ''hl.dsp.window.move({ direction = "up" })'')
              (bind "CTRL + SUPER + l" ''hl.dsp.window.move({ direction = "right" })'')

              (bind "ALT + SHIFT + 1" "hl.dsp.focus({ workspace = 1 })")
              (bind "ALT + SHIFT + 2" "hl.dsp.focus({ workspace = 2 })")
              (bind "ALT + SHIFT + 3" "hl.dsp.focus({ workspace = 3 })")
              (bind "ALT + SHIFT + 4" "hl.dsp.focus({ workspace = 4 })")
              (bind "ALT + SHIFT + 5" "hl.dsp.focus({ workspace = 5 })")
              (bind "ALT + SHIFT + 6" "hl.dsp.focus({ workspace = 6 })")
              (bind "ALT + SHIFT + 7" "hl.dsp.focus({ workspace = 7 })")
              (bind "ALT + SHIFT + 8" "hl.dsp.focus({ workspace = 8 })")
              (bind "ALT + SHIFT + 9" "hl.dsp.focus({ workspace = 9 })")
              (bind "ALT + SHIFT + 0" "hl.dsp.focus({ workspace = 10 })")

              (bind "ALT + SHIFT + KP_End"    "hl.dsp.focus({ workspace = 1 })")
              (bind "ALT + SHIFT + KP_Down"   "hl.dsp.focus({ workspace = 2 })")
              (bind "ALT + SHIFT + KP_Next"   "hl.dsp.focus({ workspace = 3 })")
              (bind "ALT + SHIFT + KP_Left"   "hl.dsp.focus({ workspace = 4 })")
              (bind "ALT + SHIFT + KP_Begin"  "hl.dsp.focus({ workspace = 5 })")
              (bind "ALT + SHIFT + KP_Right"  "hl.dsp.focus({ workspace = 6 })")
              (bind "ALT + SHIFT + KP_Home"   "hl.dsp.focus({ workspace = 7 })")
              (bind "ALT + SHIFT + KP_Up"     "hl.dsp.focus({ workspace = 8 })")
              (bind "ALT + SHIFT + KP_Prior"  "hl.dsp.focus({ workspace = 9 })")
              (bind "ALT + SHIFT + KP_Insert" "hl.dsp.focus({ workspace = 10 })")

              (bind "ALT + CTRL + 1" "hl.dsp.window.move({ workspace = 1 })")
              (bind "ALT + CTRL + 2" "hl.dsp.window.move({ workspace = 2 })")
              (bind "ALT + CTRL + 3" "hl.dsp.window.move({ workspace = 3 })")
              (bind "ALT + CTRL + 4" "hl.dsp.window.move({ workspace = 4 })")
              (bind "ALT + CTRL + 5" "hl.dsp.window.move({ workspace = 5 })")
              (bind "ALT + CTRL + 6" "hl.dsp.window.move({ workspace = 6 })")
              (bind "ALT + CTRL + 7" "hl.dsp.window.move({ workspace = 7 })")
              (bind "ALT + CTRL + 8" "hl.dsp.window.move({ workspace = 8 })")
              (bind "ALT + CTRL + 9" "hl.dsp.window.move({ workspace = 9 })")
              (bind "ALT + CTRL + 0" "hl.dsp.window.move({ workspace = 10 })")

              (bind "ALT + CTRL + KP_End"    "hl.dsp.window.move({ workspace = 1 })")
              (bind "ALT + CTRL + KP_Down"   "hl.dsp.window.move({ workspace = 2 })")
              (bind "ALT + CTRL + KP_Next"   "hl.dsp.window.move({ workspace = 3 })")
              (bind "ALT + CTRL + KP_Left"   "hl.dsp.window.move({ workspace = 4 })")
              (bind "ALT + CTRL + KP_Begin"  "hl.dsp.window.move({ workspace = 5 })")
              (bind "ALT + CTRL + KP_Right"  "hl.dsp.window.move({ workspace = 6 })")
              (bind "ALT + CTRL + KP_Home"   "hl.dsp.window.move({ workspace = 7 })")
              (bind "ALT + CTRL + KP_Up"     "hl.dsp.window.move({ workspace = 8 })")
              (bind "ALT + CTRL + KP_Prior"  "hl.dsp.window.move({ workspace = 9 })")
              (bind "ALT + CTRL + KP_Insert" "hl.dsp.window.move({ workspace = 10 })")

              (bind "ALT + Page_Down" ''hl.dsp.focus({ workspace = "e-1" })'')
              (bind "ALT + Page_Up"   ''hl.dsp.focus({ workspace = "e+1" })'')
              (bind "ALT + Home"      ''hl.dsp.focus({ workspace = "previous" })'')

              (bind "ALT + SHIFT + S" ''hl.dsp.workspace.toggle_special("magic")'')
              (bind "ALT + CTRL + S"  ''hl.dsp.window.move({ workspace = "special:magic" })'')

              (bind "CTRL + SHIFT + ALT + F" "hl.dsp.window.float()")
              (bind "CTRL + SHIFT + ALT + T" ''hl.dsp.layout("togglesplit")'')

              (bind "CTRL + SHIFT + ALT + S" ''hl.dsp.exec_cmd("${pkgs.hyprshot}/bin/hyprshot -m region")'')
              (bind "CTRL + SHIFT + S"       ''hl.dsp.exec_cmd("${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only")'')

              (bind "XF86AudioRaiseVolume" ''hl.dsp.exec_cmd("wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+")'')
              (bind "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-")'')
              (bind "XF86AudioMute"        ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'')

              (bind "XF86AudioPlay"  ''hl.dsp.exec_cmd("${pkgs.playerctl}/bin/playerctl play-pause")'')
              (bind "XF86AudioPause" ''hl.dsp.exec_cmd("${pkgs.playerctl}/bin/playerctl play-pause")'')
              (bind "XF86AudioNext"  ''hl.dsp.exec_cmd("${pkgs.playerctl}/bin/playerctl next")'')
              (bind "XF86AudioPrev"  ''hl.dsp.exec_cmd("${pkgs.playerctl}/bin/playerctl previous")'')

              (bind "ALT + CTRL + L" ''hl.dsp.exec_cmd("hyprlock")'')

              (bindMouse "ALT + mouse:272" "hl.dsp.window.drag()")
              (bindMouse "ALT + mouse:273" "hl.dsp.window.resize()")
            ];
          };
        };
      }
    )
  ];
}
