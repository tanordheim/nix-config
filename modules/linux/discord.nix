{ config, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "discord-pwa" ''
      ${pkgs.chromium}/bin/chromium \
        --app="https://discord.com/channels/@me" \
        --class="discord-pwa" \
        --user-data-dir="$HOME/.config/discord-pwa" \
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
