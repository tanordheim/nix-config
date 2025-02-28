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
      "default-web-browser" = [ "chromium.desktop" ];
      "text/html" = [ "chromium.desktop" ];
      "x-scheme-handler/http" = [ "chromium.desktop" ];
      "x-scheme-handler/https" = [ "chromium.desktop" ];
      "x-scheme-handler/about" = [ "chromium.desktop" ];
      "x-scheme-handler/unknown" = [ "chromium.desktop" ];
    };
  };
}
