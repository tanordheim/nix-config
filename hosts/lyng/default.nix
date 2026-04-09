{ inputs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.stylix.darwinModules.stylix

    ../common/global
    ../common/users/trond.nix

    ../common/optional/docker.nix
    ../common/optional/darwin/1password.nix
    ../common/optional/darwin/android-studio.nix
    ../common/optional/darwin/docker.nix
    ../common/optional/darwin/camo.nix
    ../common/optional/darwin/chrome.nix
    ../common/optional/darwin/claude-desktop.nix
    ../common/optional/darwin/discord.nix
    ../common/optional/darwin/firefox.nix
    ../common/optional/darwin/homebrew.nix
    ../common/optional/darwin/kubernetes.nix
    ../common/optional/darwin/linear.nix
    ../common/optional/darwin/logitech.nix
    ../common/optional/darwin/nix.nix
    ../common/optional/darwin/obsidian.nix
    ../common/optional/darwin/pdfexpert.nix
    ../common/optional/darwin/pocketcasts.nix
    ../common/optional/darwin/proton.nix
    ../common/optional/darwin/raycast.nix
    ../common/optional/darwin/signal.nix
    ../common/optional/darwin/slack.nix
    ../common/optional/darwin/spotify.nix
    ../common/optional/darwin/stylix.nix
    ../common/optional/darwin/system-defaults.nix
    ../common/optional/darwin/teams.nix
    ../common/optional/darwin/telegram.nix
    ../common/optional/darwin/touch-id.nix
    ../common/optional/darwin/whatsapp.nix
    ../common/optional/darwin/wispr-flow.nix
    ../common/optional/darwin/xcode.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
  system.primaryUser = "trond";
  networking.hostName = "lyng";
  home-manager.users.trond.home.stateVersion = "24.11";
}
