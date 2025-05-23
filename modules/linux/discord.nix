{ config, pkgs, ... }:

{
  environment.systemPackages = [
    # TODO: remove js-flags when chromium v31 fixes decommit-pooled-pages issue on systems with 16k pages
    (pkgs.writeShellScriptBin "discord-pwa" ''
      ${pkgs.stable.chromium}/bin/chromium \
        --app="https://discord.com/channels/@me" \
        --class="discord-pwa" \
        --user-data-dir="$HOME/.config/discord-pwa" \
        --js-flags=--no-decommit-pooled-pages \
        --enable-features=WebAppEnableUrlHandlers \
        --enable-features=WebAppEnableDarkMode \
        --disable-notifications \
        --protocol-handler=discord \
        --no-default-browser-check \
        --disable-features=DefaultBrowserInSettingsMenu \
        --ozone-platform=wayland \
        --allow-external-pages=false \
        "$@"
    '')

    (pkgs.makeDesktopItem {
      name = "discord-pwa";
      desktopName = "Discord";
      exec = "discord-pwa %U";
      icon = "discord";
      categories = [
        "Network"
        "InstantMessaging"
      ];
      terminal = false;
      mimeTypes = [ "x-scheme-handler/discord" ];
    })
  ];

  home-manager.users.${config.username}.xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/discord" = "discord-pwa.desktop";
  };
}
