{
  pkgs,
  config,
  ...
}:
{
  home-manager.users.${config.username} = {
    stylix.targets.firefox.profileNames = [ "default" ];
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          settings = {
            "browser.download.dir" = "/home/${config.username}/downloads";
            "middlemouse.paste" = false;
            "privacy.donottrackheader.enabled" = true;
          };
        };
      };
      policies = {
        DisableTelemetry = true;
        PasswordManagerEnabled = false;
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
