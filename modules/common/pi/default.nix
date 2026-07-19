{
  ...
}:
{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.pi-coding-agent ];
      }
    )
  ];
}
