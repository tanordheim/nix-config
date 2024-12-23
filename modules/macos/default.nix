{
  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 5;

  imports = [
    ../common
    ./1password.nix
    ./aerospace.nix
    ./awsvpn.nix
    ./brave.nix
    ./chromium.nix
    ./discord.nix
    ./homebrew.nix
    ./linear.nix
    ./nix.nix
    ./obsidian.nix
    ./orbstack.nix
    ./raycast.nix
    ./sketchybar.nix
    ./slack.nix
    ./system-defaults.nix
    ./touch-id.nix
    ./users.nix
    ./wallpaper.nix
  ];

  # Automatically reload settings from the database and apply them to the current session, avoiding relog to get changes to take effect
  system.activationScripts.postUserActivation.text = ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}