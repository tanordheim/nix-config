{
  flake.modules.homeManager.chromium =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.chromium.enable {
        programs.chromium = {
          enable = true;
          package = pkgs.chromium.override { enableWideVine = true; };
          extensions = [
            "aeblfdkhhhdcdjpifhhbdiojplfjncoa"
            "hfhaalldkgmfbjjehkiddheghljjdjln"
            "egikgfbhipinieabdmcpigejkaomgjgb"
          ];
        };
        xdg.mimeApps.defaultApplications = {
          "default-web-browser" = "chromium-desktop.desktop";
          "text/html" = "chromium-desktop.desktop";
          "x-scheme-handler/http" = "chromium-desktop.desktop";
          "x-scheme-handler/https" = "chromium-desktop.desktop";
          "x-scheme-handler/about" = "chromium-desktop.desktop";
          "x-scheme-handler/unknown" = "chromium-desktop.desktop";
        };
      };
    };
}
