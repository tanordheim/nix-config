{
  # https://macos-defaults.com/finder/
  system.defaults.CustomUserPreferences."com.apple.finder" = {
    AppleShowAllExtensions = true; # always show all file extensions
    AppleShowAllFiles =true; # always show hidden files
    ShowPathbar = true; # show path bar at the bottom of the window
    FXPreferredViewStyle = "Nlsv"; # use column view by default
    FXDefaultSearchScope = "SCcf"; # default search to use the current folder
    _FXSortFoldersFirst = true; # place folders first when sorting by name
    FXEnableExtensionChangeWarning = false; # dont warn when changing file extensions
    NSDocumentSaveNewDocumentsToCloud = false; # dont offer to save new documents to iCloud by default
    CreateDesktop = false; # dont show icons on the desktop
    ShowHardDrivesOnDesktop = false; # don't show harddrives on the desktop
    ShowExternalHardDrivesOnDesktop = false; # don't show external harddrives on the desktop
    ShowRemovableMediaOnDesktop = false; # don't show removable media on the desktop
    ShowMountedServersOnDesktop = false; # don't show mounted network storage on the desktop
  };

  system.defaults.CustomUserPreferences."com.apple.desktopservices" = {
    DSDontWriteNetworkStores = true; # dont create .DS_Store files on network stores
    DSDontWriteUSBStores = true; # dont create .DS_Store files on usb stores
  };
}
