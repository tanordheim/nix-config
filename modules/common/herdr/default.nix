{
  inputs,
  pkgs,
  ...
}:
let
  herdrEven = pkgs.writeShellScriptBin "herdr-even" ''
    exec ${pkgs.python3}/bin/python3 ${./herdr-even.py} "$@"
  '';
  fingersBin = pkgs.rustPlatform.buildRustPackage {
    pname = "herdr-tiny-fingers";
    version = "0.1.0";
    src = inputs.herdr-tiny-fingers;
    cargoLock.lockFile = "${inputs.herdr-tiny-fingers}/Cargo.lock";
  };
  fingersPlugin = pkgs.runCommand "herdr-tiny-fingers" { } ''
    cp -r ${inputs.herdr-tiny-fingers} $out
    chmod -R u+w $out
    substituteInPlace $out/herdr-plugin.toml \
      --replace-fail '["./target/release/herdr-tiny-fingers"]' \
        '["${fingersBin}/bin/herdr-tiny-fingers"]'
  '';
  # WORKAROUND: herdr-nvim-nav is not available in nixpkgs or through nixvim.
  navigatorPlugin = pkgs.stdenv.mkDerivation {
    pname = "herdr-nvim-nav";
    version = "1.0.0";
    src = inputs.herdr-nvim-nav;
    dontConfigure = true;
    buildPhase = ''
      runHook preBuild
      $CC -O2 -o herdr-nvim-nav herdr-nvim-nav.c
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp herdr-plugin.toml herdr-nvim-nav $out/
      runHook postInstall
    '';
  };
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      let
        c = config.lib.stylix.colors.withHashtag;

        configToml = ''
          [theme.custom]
          accent = "${c.base0E}"

          [ui]
          prompt_new_tab_name = false
          sidebar_width = 40
          sidebar_min_width = 22
          sidebar_max_width = 44

          [ui.sidebar.agents]
          rows = [
            ["state_icon", "workspace", "tab"],
            [{ token = "state_text", dim = false }, { token = "agent", dim = false }],
          ]

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
          focus_pane_left = ""
          focus_pane_down = ""
          focus_pane_up = ""
          focus_pane_right = ""
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
          key = "ctrl+h"
          type = "plugin_action"
          command = "herdr-nvim-nav.left"
          description = "Navigate left"

          [[keys.command]]
          key = "ctrl+j"
          type = "plugin_action"
          command = "herdr-nvim-nav.down"
          description = "Navigate down"

          [[keys.command]]
          key = "ctrl+k"
          type = "plugin_action"
          command = "herdr-nvim-nav.up"
          description = "Navigate up"

          [[keys.command]]
          key = "ctrl+l"
          type = "plugin_action"
          command = "herdr-nvim-nav.right"
          description = "Navigate right"

          [[keys.command]]
          key = "prefix+shift+f"
          type = "plugin_action"
          command = "hotchpotch.herdr-tiny-fingers.open"
          description = "Fingers"

          [[keys.command]]
          key = "prefix+plus"
          type = "shell"
          command = "${herdrEven}/bin/herdr-even --apply"
          description = "Balance panes"
        '';

        pluginsJson = builtins.toJSON [
          {
            plugin_id = "hotchpotch.herdr-tiny-fingers";
            name = "herdr-tiny-fingers";
            version = "0.1.0";
            manifest_path = "${fingersPlugin}/herdr-plugin.toml";
            plugin_root = "${fingersPlugin}";
            enabled = true;
            source.kind = "local";
          }
          {
            plugin_id = "herdr-nvim-nav";
            name = "Vim Nav";
            version = "0.1.0";
            manifest_path = "${navigatorPlugin}/herdr-plugin.toml";
            plugin_root = "${navigatorPlugin}";
            enabled = true;
            source.kind = "local";
          }
        ];
      in
      {
        home.packages = [
          pkgs.herdr
          herdrEven
        ];
        xdg.configFile."herdr/config.toml".text = configToml;
        xdg.configFile."herdr/plugins.json".text = pluginsJson;
      }
    )
  ];
}
