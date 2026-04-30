{ config, inputs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    ../common/_overlays.nix
    ../common/base
    ../common/fonts
    ../common/sudo
    ../common/timezone
    ../common/hm-base
    ../common/zsh
    ../common/git
    ../common/ssh
    ../common/starship
    ../common/eza
    ../common/zoxide
    ../common/direnv
    ../common/shell-aliases
    ../common/build-tools
    ../common/users/trond
    ../common/stylix
  ];

  nix = {
    settings = {
      trusted-users = [ "root" ];
      experimental-features = "nix-command flakes";
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
      interval.Day = 7;
    };
    optimise.automatic = true;
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = config.system.primaryUser;
    autoMigrate = true;
    mutableTaps = false;

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [ "mas" ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    ".GlobalPreferences" = {
      "com.apple.mouse.scaling" = 2.0;
    };

    ActivityMonitor = {
      SortColumn = "CPUUsage";
      SortDirection = 0;
    };
    CustomUserPreferences = {
      "/Users/${config.system.primaryUser}/Library/Preferences/ByHost/com.apple.controlcenter.plist" = {
        "AirplayReceiverEnabled" = 0;
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.finder" = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        ShowPathbar = true;
        FXPreferredViewStyle = "Nlsv";
        FXDefaultSearchScope = "SCcf";
        _FXSortFoldersFirst = true;
        FXEnableExtensionChangeWarning = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        CreateDesktop = false;
        ShowHardDrivesOnDesktop = false;
        ShowExternalHardDrivesOnDesktop = false;
        ShowRemovableMediaOnDesktop = false;
        ShowMountedServersOnDesktop = false;
      };
      "com.apple.screensaver" = {
        askForPassword = 1;
        askForPasswordDelay = 1;
      };
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "28" = {
            enabled = false;
          };
          "29" = {
            enabled = false;
          };
          "30" = {
            enabled = false;
          };
          "31" = {
            enabled = true;
            value = {
              parameters = [
                115
                1
                655360
              ];
              type = "standard";
            };
          };
          "32" = {
            enabled = false;
          };
          "33" = {
            enabled = false;
          };
          "64" = {
            enabled = false;
          };
          "73" = {
            enabled = true;
            value = {
              parameters = [
                108
                37
                1179648
              ];
              type = "standard";
            };
          };
          "79" = {
            enabled = false;
          };
          "81" = {
            enabled = false;
          };
          "184" = {
            enabled = false;
          };
        };
      };
    };
    dock = {
      appswitcher-all-displays = true;
      autohide = true;
      show-recents = false;
      tilesize = 48;
      persistent-apps = [ ];
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };
    loginwindow = {
      GuestEnabled = false;
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
      _HIHideMenuBar = false;
      "com.apple.swipescrolldirection" = false;
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      AppleMeasurementUnits = "Centimeters";
      ApplePressAndHoldEnabled = false;
      AppleShowScrollBars = "Always";
      AppleTemperatureUnit = "Celsius";
      InitialKeyRepeat = 25;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSWindowShouldDragOnGesture = true;
      PMPrintingExpandedStateForPrint = true;
    };
    SoftwareUpdate = {
      AutomaticallyInstallMacOSUpdates = true;
    };
    spaces = {
      spans-displays = true;
    };
    WindowManager = {
      StandardHideWidgets = true;
      EnableStandardClickToShowDesktop = false;
    };
  };

  system.activationScripts.postActivation.text = ''
    sudo -u ${config.system.primaryUser} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
