{
  lib,
  pkgs,
  config,
  ...
}:
let
  plugins = import ./plugins.nix { inherit pkgs; };
  versionMajorMinor = lib.versions.majorMinor pkgs.jetbrains.datagrip.version;

  vmOptionsFile =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/JetBrains/GoLand${versionMajorMinor}/goland.vmoptions"
    else
      ".config/JetBrains/GoLand${versionMajorMinor}/goland64.vmoptions";

  vmOptionsContent =
    if pkgs.stdenv.isDarwin then
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
  home-manager.users.${config.username}.home = {
    packages = [
      (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.goland plugins)
    ];

    file = {
      "${vmOptionsFile}".text = vmOptionsContent;
    };
  };
}
