{ config, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "slack-pwa" ''
      ${pkgs.brave}/bin/brave \
        --app="https://app.slack.com/client" \
        --class="slack-pwa" \
        --user-data-dir="$HOME/.config/slack-pwa" \
        --enable-features=WebAppEnableUrlHandlers \
        --enable-features=WebAppEnableDarkMode \
        --enable-notifications \
        --protocol-handler=slack \
        --no-default-browser-check \
        --disable-features=DefaultBrowserInSettingsMenu \
        --ozone-platform=wayland \
        --js-flags=--no-decommit-pooled-pages \
        "$@"
    '')

    # Desktop entry with additional mime-type handling
    (pkgs.makeDesktopItem {
      name = "slack-pwa";
      desktopName = "Slack";
      exec = "slack-pwa %U"; # %U allows URL handling
      icon = "slack";
      categories = [
        "Network"
        "InstantMessaging"
      ];
      terminal = false;
      mimeTypes = [ "x-scheme-handler/slack" ]; # Register for slack:// URLs
    })
  ];

  my.user.xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/slack" = "slack-pwa.desktop";
  };
}
