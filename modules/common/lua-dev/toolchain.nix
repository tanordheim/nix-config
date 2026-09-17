{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.lua5_1
          pkgs.lua51Packages.busted
          pkgs.lua51Packages.luacheck
          pkgs.stylua
        ];
      }
    )
  ];
}
