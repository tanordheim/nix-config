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
    ./keyboard.nix
    ./kitty.nix
    ./kubernetes.nix
    ./linear.nix
    ./logitech.nix
    ./nix.nix
    ./obs.nix
    ./obsidian.nix
    ./pdfexpert.nix
    ./proton.nix
    ./raycast.nix
    ./signal.nix
    ./sketchybar.nix
    ./slack.nix
    ./spotify.nix
    ./stylix.nix
    ./system-defaults.nix
    ./teams.nix
    ./touch-id.nix
    ./users.nix
    ./whatsapp.nix
    ./xcode
  ];

  system.primaryUser = "trond";
}
