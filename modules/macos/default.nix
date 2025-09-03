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
    ./cocoapods.nix
    ./discord.nix
    ./firefox.nix
    ./homebrew.nix
    ./java.nix
    ./linear.nix
    ./logitech.nix
    ./nix.nix
    ./obsidian.nix
    ./orbstack.nix
    ./raycast.nix
    ./sketchybar.nix
    ./slack.nix
    ./spotify.nix
    ./stylix.nix
    ./system-defaults.nix
    ./touch-id.nix
    ./users.nix
  ];

  system.primaryUser = "trond";
}
