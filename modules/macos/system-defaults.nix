{ lib, config, ... }:
{
  # https://macos-defaults.com/finder/

  system.defaults = {
    ".GlobalPreferences" = {
      "com.apple.mouse.scaling" = 2.0;
    };

    ActivityMonitor = {
      SortColumn = "CPUUsage";
      SortDirection = 0; # descending
    };
    CustomUserPreferences = {
      "/Users/${config.username}/Library/Preferences/ByHost/com.apple.controlcenter.plist" = {
        "AirplayReceiverEnabled" = 0; # disable airplay receiver binding to port 5000 and 7000
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true; # dont create .DS_Store files on network stores
        DSDontWriteUSBStores = true; # dont create .DS_Store files on usb stores
      };
      "com.apple.finder" = {
        AppleShowAllExtensions = true; # always show all file extensions
        AppleShowAllFiles = true; # always show hidden files
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
      "com.apple.screensaver" = {
        # ask for password immediately after sleep or after screensaver has started
        askForPassword = 1;
        askForPasswordDelay = 1;
      };
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "28" = {
            enabled = false; # screenshot entire screen
          };
          "30" = {
            enabled = false; # screenshot portion of screen
          };
          "32" = {
            enabled = false; # mission control
          };
          "33" = {
            enabled = false; # application windows
          };
          "64" = {
            enabled = false; # spotlight
          };
          "79" = {
            enabled = false; # move space left
          };
          "81" = {
            enabled = false; # move space right
          };
          "184" = {
            enabled = false; # screenshot / recording toolbar
          };
        };
      };
    };
    dock = {
      appswitcher-all-displays = true; # show app switcher across all displays
      autohide = true;
      show-recents = false; # don't showrecent apps in the dock
      tilesize = 48;

      # apps pinned to the dock
      persistent-apps = [ ];

      # disable all hot corners
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };
    loginwindow = {
      GuestEnabled = false; # disable guest user
    };
    menuExtraClock = {
      IsAnalog = false;
      Show24Hour = true;
      ShowAMPM = false;
      ShowDate = 1;
      ShowDayOfMonth = true;
      ShowDayOfWeek = true;
      ShowSeconds = false;
    };
    NSGlobalDomain = {
      _HIHideMenuBar = false; # auto hide the menu bar
      "com.apple.swipescrolldirection" = false; # disable natural scroll
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      AppleMeasurementUnits = "Centimeters";
      ApplePressAndHoldEnabled = false;
      AppleShowScrollBars = "Always"; # always show scroll bars
      AppleTemperatureUnit = "Celsius";
      InitialKeyRepeat = 25;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true; # show expanded save dialog by default
      NSWindowShouldDragOnGesture = true; # click to move windows
      PMPrintingExpandedStateForPrint = true; # show expanded print dialog by default
    };
    SoftwareUpdate = {
      AutomaticallyInstallMacOSUpdates = true;
    };
    spaces = {
      spans-displays = true; # use same space across all displays, works better with AeroSpace
    };
    WindowManager = {
      StandardHideWidgets = true; # hide widgets on desktop
      EnableStandardClickToShowDesktop = false; # disable click to show desktop
    };
  };

  system.activationScripts.postActivation.text = ''
    sudo -u ${config.username} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
