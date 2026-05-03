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
              userChrome = ''
                :root {
                  --tab-min-height: 30px !important;
                }
                .tabbrowser-tab .tab-label,
                .tabbrowser-tab .tab-icon-stack,
                #nav-bar,
                #urlbar,
                #PersonalToolbar,
                menupopup,
                menuitem,
                menu {
                  font-size: 11px !important;
                }
              '';
              userContent = ''
                @-moz-document url-prefix("about:") {
                  :root { font-size: 13px !important; }
                }
              '';
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
