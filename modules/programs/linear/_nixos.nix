{ config, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "linear-pwa" ''
      ${pkgs.chromium}/bin/chromium \
        --app="https://linear.app" \
        --class="linear-pwa" \
        --user-data-dir="$HOME/.config/linear-pwa" \
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

  my.user.xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/linear" = "linear-pwa.desktop";
  };
}
