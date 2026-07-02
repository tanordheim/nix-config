{
  inputs,
  pkgs,
  ...
}:
let
  herdrPkg = inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default;

  configToml = ''
    [theme]
    name = "catppuccin"

    [theme.custom]
    accent = "#b4befe"
    surface_dim = "#494258"

    [keys]
    prefix = "ctrl+space"
    detach = "prefix+d"
    split_horizontal = "prefix+s"
    settings = "prefix+comma"
    workspace_picker = "prefix+o"
    open_notification_target = "prefix+minus"
    focus_pane_left = ["prefix+h", "ctrl+h"]
    focus_pane_down = ["prefix+j", "ctrl+j"]
    focus_pane_up = ["prefix+k", "ctrl+k"]
    focus_pane_right = ["prefix+l", "ctrl+l"]
  '';
in
{
  home-manager.sharedModules = [
    {
      home.packages = [ herdrPkg ];
      xdg.configFile."herdr/config.toml".text = configToml;
    }
  ];
}
