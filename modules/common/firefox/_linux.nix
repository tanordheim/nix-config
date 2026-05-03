{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        stylix.targets.firefox.profileNames = [ "default" ];
        programs.firefox = {
          enable = true;
          profiles = {
            default = {
              id = 0;
              name = "default";
              settings = {
                "middlemouse.paste" = false;
              };
            };
          };
          policies = {
            DisableTelemetry = true;
            PasswordManagerEnabled = false;
            DownloadDirectory = "${config.home.homeDirectory}/downloads";
            UseSystemPrintDialog = true;
            Preferences = {
              "privacy.globalprivacycontrol.enabled" = {
                Value = true;
                Status = "locked";
              };
              "layout.css.devPixelsPerPx" = {
                Value = "0.9";
                Status = "locked";
                Type = "string";
              };
            };
          };
        };
        xdg.mimeApps.defaultApplications = {
          "default-web-browser" = "firefox.desktop";
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefoxchromium-desktop.desktop";
        };
      }
    )
  ];
}
