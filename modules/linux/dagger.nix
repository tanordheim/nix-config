{
  pkgs,
  config,
  dagger,
  ...
}:
{
  home-manager.users.${config.username}.home.packages = [ dagger.packages.${pkgs.system}.dagger ];
}
