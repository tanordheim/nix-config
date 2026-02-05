{
  lib,
  pkgs,
  config,
  ...
}:
let
  versionMajorMinor = lib.versions.majorMinor pkgs.jetbrains.pycharm.version;

  # vmOptionsFile =
  #   if pkgs.stdenv.isDarwin then
  #     "Library/Application Support/JetBrains/Pycharm${versionMajorMinor}/rider.vmoptions"
  #   else
  #     ".config/JetBrains/Pycharm${versionMajorMinor}/rider64.vmoptions";
  #
  # vmOptionsContent =
  #   if pkgs.stdenv.isDarwin then
  #     ''
  #       -Xms1g
  #       -Xmx2g
  #     ''
  #   else
  #     ''
  #       -Xms1g
  #       -Xmx2g
  #       -Dawt.toolkit.name=WLToolkit
  #     '';
in
{
  home-manager.users.${config.username}.home = {
    packages = with pkgs; [ jetbrains.pycharm ];
    # file = {
    #   "${vmOptionsFile}".text = vmOptionsContent;
    # };
  };
}
