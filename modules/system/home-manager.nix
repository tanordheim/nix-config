{ config, lib, catppuccin, ... }:
{
  imports = [
    (lib.mkAliasOptionModule
      [ "my" "user" ]
      [ "home-manager" "users" config.d.user.name ])
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  my.user = {
    home = {
      homeDirectory = config.my.osUser.home;
      stateVersion = config.d.stateVersion;
    };
    imports = [catppuccin.homeManagerModules.catppuccin];
    catppuccin.flavor = "mocha";
    xdg.enable = true;
    programs.home-manager.enable = true;
  };
}
