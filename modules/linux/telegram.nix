{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
    "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
  };
}
