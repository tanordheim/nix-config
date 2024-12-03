{ config, pkgs, ... }:
let
  dotnet-packages = with pkgs; with dotnetCorePackages; combinePackages [
    sdk_9_0
    sdk_8_0
  ];

in
{
  environment.systemPackages = [dotnet-packages];

  my.user.home.sessionPath = [
    "${config.my.osUser.home}/.dotnet/tools"
  ];

  my.user.home.sessionVariables = {
    DOTNET_ROOT = "${dotnet-packages}";
  };
}
