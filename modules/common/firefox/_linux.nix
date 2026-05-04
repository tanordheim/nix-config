{
  home-manager.sharedModules = [
    (
      { config, lib, ... }:
      let
        cfg = config.firefox;

        commonSettings = {
          "middlemouse.paste" = false;
        };

        accentChromeCss = color: ''
          :root,
          #main-window,
          #navigator-toolbox,
          #titlebar,
          #TabsToolbar,
          #nav-bar {
            background-color: ${color} !important;
            --toolbar-bgcolor: ${color} !important;
            --lwt-accent-color: ${color} !important;
          }
        '';

        consumerProfiles = lib.listToAttrs (
          lib.imap1 (i: name: {
            inherit name;
            value =
              let
                p = cfg.profiles.${name};
                hasAccent = p.accentColor != null;
              in
              {
                id = i;
                name = p.name;
                settings =
                  commonSettings
                  // lib.optionalAttrs hasAccent {
                    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                  };
              }
              // lib.optionalAttrs hasAccent {
                userChrome = accentChromeCss p.accentColor;
              };
          }) (lib.attrNames cfg.profiles)
        );
      in
      {
        options.firefox.profiles = lib.mkOption {
          default = { };
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Display name shown in the legacy profile picker.";
                };
                accentColor = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Optional chrome accent color (e.g. \"#1e6091\").";
                };
              };
            }
          );
        };

        config = {
          stylix.targets.firefox.profileNames = [ "default" ] ++ lib.attrNames cfg.profiles;
          programs.firefox = {
            enable = true;
            profiles = {
              default = {
                id = 0;
                name = "default";
                settings = commonSettings;
              };
            }
            // consumerProfiles;
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
        };
      }
    )
  ];
}
