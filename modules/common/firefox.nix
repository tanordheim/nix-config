{
  pkgs,
  config,
  ...
}:
let
  downloadDirectory =
    if pkgs.stdenv.isDarwin then
      "/Users/${config.username}/Downloads"
    else
      "/home/${config.username}/downloads";

in
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
            "browser.download.dir" = downloadDirectory;
            "middlemouse.paste" = false;
            "privacy.donottrackheader.enabled" = true;
          };
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            onepassword-password-manager
          ];
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
