{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.swiftformat
          pkgs.swiftlint
        ];
      }
    )
  ];
}
