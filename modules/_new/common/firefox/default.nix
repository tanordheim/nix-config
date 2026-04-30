{
  pkgs,
  lib,
  isDarwin,
  ...
}:
{
  imports = [ (lib.mkPlatformImport ./. isDarwin) ];

  home-manager.sharedModules = [
    (
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        stylix.targets.firefox.profileNames = lib.mkIf pkgs.stdenv.isLinux [ "default" ];
        programs.firefox = lib.mkIf pkgs.stdenv.isLinux {
          enable = true;
          profiles = {
            default = {
              id = 0;
              name = "default";
              settings = {
                "browser.download.dir" = "${config.home.homeDirectory}/downloads";
                "middlemouse.paste" = false;
                "print.prefer_system_dialog" = true;
                "privacy.donottrackheader.enabled" = true;
              };
            };
          };
          policies = {
            DisableTelemetry = true;
            PasswordManagerEnabled = false;
          };
        };
        xdg.mimeApps.defaultApplications = lib.mkIf pkgs.stdenv.isLinux {
          "default-web-browser" = "firefox.desktop";
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefoxchromium-desktop.desktop";
        };

        home.file = lib.mkIf pkgs.stdenv.isDarwin {
          "Library/Application Support/Firefox/policies/policies.json".text = builtins.toJSON {
            DisableTelemetry = true;
            PasswordManagerEnabled = false;
          };
        };
      }
    )
  ];
}
