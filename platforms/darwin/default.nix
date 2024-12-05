{ ... }:
{
  imports = [
    ../common
    ./desktop.nix
    ./display.nix
    ./dock.nix
    ./finder.nix
    ./keyboard.nix
    ./login.nix
    ./network.nix
    ./mouse.nix
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 5;

  # Automatically reload settings from the database and apply them to the current session, avoiding relog to get changes to take effect
  system.activationScripts.postUserActivation.text = ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  system.defaults = {
    ActivityMonitor = {
      SortColumn = "CPUUsage";
      SortDirection = 0; # descending
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
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      AppleMeasurementUnits = "Centimeters";
      AppleTemperatureUnit = "Celsius";
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true; # show expanded save dialog by default
      PMPrintingExpandedStateForPrint = true; # show expanded print dialog by default
    };
    SoftwareUpdate = {
      AutomaticallyInstallMacOSUpdates = true;
    };
  };
}
