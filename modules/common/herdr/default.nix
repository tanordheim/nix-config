{
  inputs,
  pkgs,
  ...
}:
let
  herdrPkg = inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default;

  configToml = ''
    [keys]
    prefix = "ctrl+space"
    detach = "prefix+d"
    split_horizontal = "prefix+s"
    workspace_picker = "prefix+o"
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
