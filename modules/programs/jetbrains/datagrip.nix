{ pkgs, isDarwin, ... }:
let
  plugins = import ./plugins.nix { inherit pkgs; };

  vmOptionsFile =
    if isDarwin then
      "Library/Application Support/JetBrains/DataGrip${pkgs.jetbrains.datagrip.version}/rider.vmoptions"
    else
      ".config/JetBrains/DataGrip${pkgs.jetbrains.datagrip.version}/datagrip64.vmoptions";

  vmOptionsContent =
    if isDarwin then
      ''''
    else
      ''
        -Dawt.toolkit.name=WLToolkit
      '';
in
{
  my.user.home.packages = [
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.datagrip plugins)
  ];

  my.user.home.file = {
    "${vmOptionsFile}".text = vmOptionsContent;
  };
}
