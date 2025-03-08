{ pkgs, config, ... }:
{
  home-manager.users.${config.username} = {
    programs.chromium = {
      enable = true;
      package = pkgs.chromium.override { enableWideVine = true; };
      extensions = [
        # 1Password
        "aeblfdkhhhdcdjpifhhbdiojplfjncoa"

        # Detrumpify
        "hfhaalldkgmfbjjehkiddheghljjdjln"

        # Feedly Notifier
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
}
