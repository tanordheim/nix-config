{ pkgs, ... }:
let
  dotnet-packages =
    with pkgs;
    with dotnetCorePackages;
    combinePackages [
      sdk_10_0-bin
    ];

in
{
  home.packages = [ dotnet-packages ];

  home.sessionPath = [
    "$HOME/.dotnet/tools"
  ];
  home.sessionVariables = {
    DOTNET_ROOT = "${dotnet-packages}/share/dotnet";
  };
}
