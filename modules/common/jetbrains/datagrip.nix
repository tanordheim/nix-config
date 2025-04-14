{
  lib,
  pkgs,
  config,
  ...
}:
let
  versionMajorMinor = lib.versions.majorMinor pkgs.jetbrains.datagrip.version;

  vmOptionsFile =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/JetBrains/DataGrip${versionMajorMinor}/datagrip.vmoptions"
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
    packages = with pkgs; [ jetbrains.datagrip ];

    file = {
      "${vmOptionsFile}".text = vmOptionsContent;
    };
  };
}
