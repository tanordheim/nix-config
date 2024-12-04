{ pkgs, isDarwin, ... }:
let
  vmOptionsFile =
    if isDarwin then
      "Library/Application Support/JetBrains/Rider${pkgs.jetbrains.rider.version}/rider.vmoptions"
    else
      ".config/JetBrains/Rider${pkgs.jetbrains.rider.version}/rider.vmoptions";

in
{
  my.user.home.packages = [
    pkgs.jetbrains.rider
  ];

  my.user.home.file = {
    "${vmOptionsFile}" = {
      text = ''
      -Xms1g
      -Xmx2g
      '';
    };
  };
}
