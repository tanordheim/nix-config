{
  config,
  lib,
  catppuccin,
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
    home = {
      homeDirectory = config.my.osUser.home;
      stateVersion = config.d.stateVersion;
      pointerCursor.size = 28;
    };
    imports = [ catppuccin.homeManagerModules.catppuccin ];
    catppuccin.flavor = "mocha";
    catppuccin.pointerCursor = {
      enable = true;
    };
    xdg.enable = true;
    programs.home-manager.enable = true;
  };
}
