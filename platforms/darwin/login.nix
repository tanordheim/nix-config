{
  system.defaults.loginwindow = {
    GuestEnabled = false; # disable guest user
  };

  system.defaults.CustomUserPreferences."com.apple.screensaver" = {
    # ask for password immediately after sleep or after screensaver has started
    askForPassword = 1;
    askForPasswordDelay = 1;
  };
}
