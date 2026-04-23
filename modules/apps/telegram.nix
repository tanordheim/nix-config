{
  flake.modules.darwin.telegram =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.telegram.enable {
        homebrew.casks = [ "telegram" ];
      };
    };

  flake.modules.homeManager.telegram =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.telegram.enable {
        xdg.mimeApps.defaultApplications = {
          "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
          "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
        };
      };
    };
}
