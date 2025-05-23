{ config, pkgs, ... }:

{
  environment.systemPackages = [
    # TODO: remove js-flags when chromium v31 fixes decommit-pooled-pages issue on systems with 16k pages
    (pkgs.writeShellScriptBin "linear-pwa" ''
      ${pkgs.stable.chromium}/bin/chromium \
        --app="https://linear.app" \
        --class="linear-pwa" \
        --user-data-dir="$HOME/.config/linear-pwa" \
        --js-flags=--no-decommit-pooled-pages \
        --enable-features=WebAppEnableUrlHandlers \
        --enable-features=WebAppEnableDarkMode \
        --disable-notifications \
        --protocol-handler=linear \
        --no-default-browser-check \
        --disable-features=DefaultBrowserInSettingsMenu \
        --ozone-platform=wayland \
        --allow-external-pages=false \
        "$@"
    '')

    (pkgs.makeDesktopItem {
      name = "linear-pwa";
      desktopName = "Linear";
      exec = "linear-pwa %U";
      icon = "linear";
      terminal = false;
      mimeTypes = [ "x-scheme-handler/linear" ];
    })
  ];

  home-manager.users.${config.username}.xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/linear" = "linear-pwa.desktop";
  };
}
