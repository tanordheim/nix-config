{ config, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "slack-pwa" ''
      ${pkgs.chromium}/bin/chromium \
        --app="https://app.slack.com/client" \
        --class="slack-pwa" \
        --user-data-dir="$HOME/.config/slack-pwa" \
        --enable-features=WebAppEnableUrlHandlers \
        --enable-features=WebAppEnableDarkMode \
        --disable-notifications \
        --protocol-handler=slack \
        --no-default-browser-check \
        --disable-features=DefaultBrowserInSettingsMenu \
        --ozone-platform=wayland \
        --allow-external-pages=false \
        "$@"
    '')

    (pkgs.makeDesktopItem {
      name = "slack-pwa";
      desktopName = "Slack";
      exec = "slack-pwa %U";
      icon = "slack";
      categories = [
        "Network"
        "InstantMessaging"
      ];
      terminal = false;
      mimeTypes = [ "x-scheme-handler/slack" ];
    })
  ];

  home-manager.users.${config.username}.xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/slack" = "slack-pwa.desktop";
  };
}
