{
  inputs,
  pkgs,
  ...
}:
let
  herdrPkg = inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default;
  pythonEnv = pkgs.python3.withPackages (ps: [ ps.rich ]);
  herdrEven = pkgs.writeShellScriptBin "herdr-even" ''
    exec ${pkgs.python3}/bin/python3 ${./herdr-even.py} "$@"
  '';
  fingersPlugin = pkgs.runCommand "herdr-fingers" { } ''
    cp -r ${inputs.herdr-fingers} $out
    chmod -R u+w $out
    substituteInPlace $out/herdr-plugin.toml \
      --replace-fail '["/usr/bin/env", "python3", "./herdr_fingers.py"]' \
        '["${pythonEnv}/bin/python3", "./herdr_fingers.py"]'
  '';
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      let
        c = config.lib.stylix.colors.withHashtag;

        configToml = ''
          [theme.custom]
          accent = "${c.base07}"
          surface0 = "${c.base01}"
          surface1 = "${c.base02}"
          surface_dim = "${c.base02}"
          overlay0 = "${c.base03}"
          subtext0 = "${c.base04}"
          text = "${c.base05}"
          red = "${c.base08}"
          peach = "${c.base09}"
          yellow = "${c.base0A}"
          green = "${c.base0B}"
          teal = "${c.base0C}"
          blue = "${c.base0D}"
          mauve = "${c.base0E}"

          [ui]
          prompt_new_tab_name = false
          sidebar_width = 40
          sidebar_min_width = 22
          sidebar_max_width = 44

          [experimental]
          pane_history = true

          [keys]
          prefix = "ctrl+space"
          detach = "prefix+d"
          split_horizontal = "prefix+s"
          settings = "prefix+shift+s"
          rename_tab = "prefix+comma"
          workspace_picker = ""
          goto = "prefix+o"
          new_workspace = "prefix+shift+w"
          close_workspace = "prefix+shift+q"
          open_notification_target = "prefix+minus"
          focus_pane_left = "ctrl+h"
          focus_pane_down = "ctrl+j"
          focus_pane_up = "ctrl+k"
          focus_pane_right = "ctrl+l"
          next_workspace = "ctrl+alt+m"
          previous_workspace = "ctrl+alt+o"
          previous_agent = "ctrl+alt+i"
          next_agent = "ctrl+alt+n"
          rename_workspace = "prefix+$"
          swap_pane_left = "ctrl+alt+h"
          swap_pane_down = "ctrl+alt+j"
          swap_pane_up = "ctrl+alt+k"
          swap_pane_right = "ctrl+alt+l"

          [[keys.command]]
          key = "prefix+shift+f"
          type = "plugin_action"
          command = "herdr-fingers.finger"
          description = "Fingers"

          [[keys.command]]
          key = "prefix+plus"
          type = "shell"
          command = "${herdrEven}/bin/herdr-even --apply"
          description = "Balance panes"
        '';

        pluginsJson = builtins.toJSON [
          {
            plugin_id = "herdr-fingers";
            name = "Fingers";
            version = "0.1.0";
            manifest_path = "${fingersPlugin}/herdr-plugin.toml";
            plugin_root = "${fingersPlugin}";
            enabled = true;
            source.kind = "local";
          }
        ];
      in
      {
        home.packages = [
          herdrPkg
          herdrEven
        ];
        xdg.configFile."herdr/config.toml".text = configToml;
        xdg.configFile."herdr/plugins.json".text = pluginsJson;
      }
    )
  ];
}
