{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          ktlint
        ];
      }
    )
  ];
}
