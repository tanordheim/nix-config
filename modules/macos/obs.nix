{
  homebrew.casks = [
    "obs"
  ];

  system.defaults.CustomUserPreferences."com.apple.loginwindow" = {
    AutoLaunchedApplicationDictionary = [
      {
        Path = "/Applications/OBS.app";
        Hide = false;
      }
    ];
  };
}
