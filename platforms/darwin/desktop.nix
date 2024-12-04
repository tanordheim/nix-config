{
  system.defaults.spaces = {
    spans-displays = true; # use same space across all displays, works better with AeroSpace
  };

  system.defaults.WindowManager = {
    EnableStandardClickToShowDesktop = false; # disable click to show desktop
  };

  system.defaults.NSGlobalDomain = {
    _HIHideMenuBar = true; # auto hide the menu bar
    NSWindowShouldDragOnGesture = true; # click to move windows
  };
}
