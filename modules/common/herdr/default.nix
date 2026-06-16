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

    [keys]
    prefix = "ctrl+space"
    detach = "prefix+d"
    split_horizontal = "prefix+s"
    settings = "prefix+comma"
    workspace_picker = "prefix+o"
    open_notification_target = "prefix+minus"
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
