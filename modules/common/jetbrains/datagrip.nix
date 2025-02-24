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
      "Library/Application Support/JetBrains/DataGrip${versionMajorMinor}/rider.vmoptions"
    else
      ".config/JetBrains/DataGrip${versionMajorMinor}/datagrip64.vmoptions";

  vmOptionsContent =
    if pkgs.stdenv.isDarwin then
      ''''
    else
      ''
        -Dawt.toolkit.name=WLToolkit
      '';
in
{
  home-manager.users.${config.username}.home = {
    packages = [
      (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.datagrip plugins)
    ];

    file = {
      "${vmOptionsFile}".text = vmOptionsContent;
    };
  };
}
