{ pkgs, isDarwin, ... }:
let
  plugins = import ./plugins.nix { inherit pkgs; };

  vmOptionsFile =
    if isDarwin then
      "Library/Application Support/JetBrains/GoLand${pkgs.jetbrains.goland.version}/goland.vmoptions"
    else
      ".config/JetBrains/GoLand${pkgs.jetbrains.goland.version}/goland64.vmoptions";

  vmOptionsContent =
    if isDarwin then
      ''
        -Xms1g
        -Xmx2g
      ''
    else
      ''
        -Xms1g
        -Xmx2g
        -Dawt.toolkit.name=WLToolkit
      '';

in
{
  my.user.home.packages = [
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.goland plugins)
  ];

  my.user.home.file = {
    "${vmOptionsFile}".text = vmOptionsContent;
  };
}
