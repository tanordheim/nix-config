{ config, pkgs, ... }:
let
  dotnet-packages =
    with pkgs;
    with dotnetCorePackages;
    combinePackages [
      # latest major versions
      bleeding.dotnetCorePackages.sdk_9_0
      sdk_8_0

      # specific older versions
      sdk_9_0_1xx
    ];

in
{
  environment.systemPackages = [ dotnet-packages ];

  home-manager.users.${config.username}.home = {
    sessionPath = [
      "$HOME/.dotnet/tools"
    ];
    sessionVariables = {
      DOTNET_ROOT = "${dotnet-packages}";
    };
  };
}
