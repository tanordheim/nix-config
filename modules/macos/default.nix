{
  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 5;

  imports = [
    ../common
    ./1password.nix
    ./aerospace.nix
    ./android-studio.nix
    ./chrome.nix
    ./discord.nix
    ./docker.nix
    ./firefox.nix
    ./homebrew.nix
    ./java.nix
    ./kubernetes.nix
    ./linear.nix
    ./nix.nix
    ./obsidian.nix
    ./raycast.nix
    ./sketchybar.nix
    ./slack.nix
    ./spotify.nix
    ./stylix.nix
    ./system-defaults.nix
    ./touch-id.nix
    ./users.nix
    ./xcode.nix
  ];

  system.primaryUser = "trond";
}
