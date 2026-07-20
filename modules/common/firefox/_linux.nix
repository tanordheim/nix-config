{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        xdg.mimeApps.defaultApplications = {
          "default-web-browser" = "firefox.desktop";
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
        };
        stylix.targets.firefox.profileNames = [ "default" ];
        stylix.targets.firefox.colorTheme.enable = true;
        programs.firefox.profiles.default.extensions.settings."FirefoxColor@mozilla.com".force = true;
        programs.firefox = {
          enable = true;
          policies = {
            DisableTelemetry = true;
            PasswordManagerEnabled = false;
            DownloadDirectory = "${config.home.homeDirectory}/Downloads";
            UseSystemPrintDialog = true;
            Preferences = {
              "privacy.globalprivacycontrol.enabled" = {
                Value = true;
                Status = "locked";
              };
              "browser.profiles.enabled" = {
                Value = false;
                Status = "locked";
              };
            };
          };
        };
      }
    )
  ];
}
