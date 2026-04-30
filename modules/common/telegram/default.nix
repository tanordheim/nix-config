{
  homebrew.casks = [ "telegram" ];

  home-manager.sharedModules = [
    {
      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
      };
    }
  ];
}
