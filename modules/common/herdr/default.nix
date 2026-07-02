{
  inputs,
  pkgs,
  ...
}:
let
  herdrPkg = inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
          workspace_picker = "prefix+o"
          open_notification_target = "prefix+minus"
          focus_pane_left = "ctrl+h"
          focus_pane_down = "ctrl+j"
          focus_pane_up = "ctrl+k"
          focus_pane_right = "ctrl+l"
          next_workspace = "ctrl+n"
          previous_workspace = "ctrl+o"
          previous_agent = "ctrl+m"
          next_agent = "ctrl+p"
          rename_workspace = "prefix+$"
          swap_pane_left = "ctrl+alt+h"
          swap_pane_down = "ctrl+alt+j"
          swap_pane_up = "ctrl+alt+k"
          swap_pane_right = "ctrl+alt+l"
        '';
      in
      {
        home.packages = [ herdrPkg ];
        xdg.configFile."herdr/config.toml".text = configToml;
      }
    )
  ];
}
