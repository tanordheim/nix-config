{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          cargo
          clippy
          rustc
        ];
      }
    )
  ];
}
