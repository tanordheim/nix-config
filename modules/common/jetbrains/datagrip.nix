{ pkgs, config, ... }:
let
  plugins = import ./plugins.nix { inherit pkgs; };

  vmOptionsFile =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/JetBrains/DataGrip${pkgs.jetbrains.datagrip.version}/rider.vmoptions"
    else
      ".config/JetBrains/DataGrip${pkgs.jetbrains.datagrip.version}/datagrip64.vmoptions";

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
