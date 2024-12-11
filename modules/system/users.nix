{
  config,
  pkgs,
  lib,
  isDarwin,
  ...
}:
let
  username = config.d.user.name;
  userFullName = config.d.user.fullName;
  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

in
{
  imports = [
    (lib.mkAliasOptionModule [ "my" "osUser" ] [ "users" "users" username ])
  ];

  config = {
    my.osUser = {
      name = username;
      description = userFullName;
      home = homeDirectory;
      shell = pkgs.zsh;
    };
  };
}
