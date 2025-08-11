{
  lib,
  pkgs,
  config,
  ...
}:
let
  versionMajorMinor = lib.versions.majorMinor pkgs.jetbrains.rider.version;

  vmOptionsFile =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/JetBrains/Rider${versionMajorMinor}/rider.vmoptions"
    else
      ".config/JetBrains/Rider${versionMajorMinor}/rider64.vmoptions";

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

  # riderpkg = pkgs.custom.jetbrains.rider;
  riderpkg = pkgs.jetbrains.rider;
  # riderpkg = pkgs.jetbrains.rider.override {
  #   libxml2 = pkgs.runCommand "libxml2.so.2" { } ''
  #     install -Dm555                       \
  #       ${pkgs.libxml2.out}/lib/libxml2.so \
  #       $out/lib/libxml2.so.2
  #   '';
  # };
in
{
  home-manager.users.${config.username}.home = {
    packages = [ riderpkg ];
    file = {
      "${vmOptionsFile}".text = vmOptionsContent;
    };
  };
}
