{ config, pkgs, ... }:

{
  environment.systemPackages = [
    # TODO: remove js-flags when chromium v31 fixes decommit-pooled-pages issue on systems with 16k pages
    (pkgs.writeShellScriptBin "slack-pwa" ''
      ${pkgs.chromium}/bin/chromium \
        --app="https://app.slack.com/client" \
        --class="slack-pwa" \
        --user-data-dir="$HOME/.config/slack-pwa" \
        --js-flags=--no-decommit-pooled-pages \
        --enable-features=WebAppEnableUrlHandlers \
        --enable-features=WebAppEnableDarkMode \
        --disable-notifications \
        --protocol-handler=slack \
        --no-default-browser-check \
        --disable-features=DefaultBrowserInSettingsMenu \
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
