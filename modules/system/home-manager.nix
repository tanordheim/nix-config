{
  config,
  lib,
  catppuccin,
  isLinux,
  ...
}:
{
  imports = [
    (lib.mkAliasOptionModule [ "my" "user" ] [ "home-manager" "users" config.d.user.name ])
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  my.user = {
    home = lib.mkMerge [
      {
        homeDirectory = config.my.osUser.home;
        stateVersion = config.d.stateVersion;
      }
      (lib.mkIf isLinux {
        pointerCursor.size = 28;
      })
    ];
    imports = [ catppuccin.homeManagerModules.catppuccin ];
    catppuccin = lib.mkMerge [
      {
        flavor = "mocha";
      }
      (lib.mkIf isLinux {
        pointerCursor.enable = true;
      })
    ];
    xdg.enable = true;
    programs.home-manager.enable = true;
  };
}
