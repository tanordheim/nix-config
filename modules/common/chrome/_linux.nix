{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.google-chrome ];
        xdg.mimeApps.defaultApplications = {
          "default-web-browser" = "google-chrome.desktop";
          "text/html" = "google-chrome.desktop";
          "x-scheme-handler/http" = "google-chrome.desktop";
          "x-scheme-handler/https" = "google-chrome.desktop";
          "x-scheme-handler/about" = "google-chrome.desktop";
        };
      }
    )
  ];
}
