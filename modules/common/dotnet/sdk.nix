{ config, pkgs, ... }:
let
  dotnet-packages =
    with pkgs;
    with dotnetCorePackages;
    combinePackages [
      sdk_9_0
      sdk_8_0
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
