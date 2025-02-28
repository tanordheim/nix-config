{ pkgs, config, ... }:
{
  home-manager.users.${config.username} = {
    programs.chromium = {
      enable = true;
      package = pkgs.chromium;
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
      "default-web-browser" = [ "org.chromium.Chromium.desktop" ];
      "text/html" = [ "org.chromium.Chromium.desktop" ];
      "x-scheme-handler/http" = [ "org.chromium.Chromium.desktop" ];
      "x-scheme-handler/https" = [ "org.chromium.Chromium.desktop" ];
      "x-scheme-handler/about" = [ "org.chromium.Chromium.desktop" ];
      "x-scheme-handler/unknown" = [ "org.chromium.Chromium.desktop" ];
    };
  };
}
