{
  config,
  pkgs,
  lib,
  isDarwin,
  isLinux,
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
    my.osUser = lib.mkMerge [
      {
        name = username;
        description = userFullName;
        home = homeDirectory;
        shell = pkgs.zsh;
      }
      (lib.mkIf isLinux {
        extraGroups = [ "wheel" ];
        isStandardUser = true;
      })
    ];
  };
}
