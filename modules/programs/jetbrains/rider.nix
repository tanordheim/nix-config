{ pkgs, isDarwin, ... }:
let
  plugins = import ./plugins.nix { inherit pkgs; };

  vmOptionsFile =
    if isDarwin then
      "Library/Application Support/JetBrains/Rider${pkgs.jetbrains.rider.version}/rider.vmoptions"
    else
      ".config/JetBrains/Rider${pkgs.jetbrains.rider.version}/rider64.vmoptions";

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
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.rider plugins)
  ];

  my.user.home.file = {
    "${vmOptionsFile}".text = vmOptionsContent;
  };
}
