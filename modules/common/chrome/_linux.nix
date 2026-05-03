{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [
          (pkgs.google-chrome.override {
            commandLineArgs = [ "--force-device-scale-factor=0.9" ];
          })
        ];
      }
    )
  ];
}
