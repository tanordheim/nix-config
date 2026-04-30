{
  imports = [
    ../../modules/_new/darwin/_base.nix

    ../../modules/_new/common/_1password
    ../../modules/_new/common/aerospace
    ../../modules/_new/common/android-studio
    ../../modules/_new/common/atuin
    ../../modules/_new/common/audacity
    ../../modules/_new/common/camo
    ../../modules/_new/common/chrome
    ../../modules/_new/common/claude
    ../../modules/_new/common/claude-desktop
    ../../modules/_new/common/discord
    ../../modules/_new/common/docker
    ../../modules/_new/common/firefox
    ../../modules/_new/common/gaming
    ../../modules/_new/common/gdrive
    ../../modules/_new/common/kitty
    ../../modules/_new/common/linear
    ../../modules/_new/common/logitech
    ../../modules/_new/common/obsidian
    ../../modules/_new/common/pdfexpert
    ../../modules/_new/common/pocketcasts
    ../../modules/_new/common/proton
    ../../modules/_new/common/qmk
    ../../modules/_new/common/raycast
    ../../modules/_new/common/signal
    ../../modules/_new/common/slack
    ../../modules/_new/common/spotify
    ../../modules/_new/common/syncthing
    ../../modules/_new/common/teams
    ../../modules/_new/common/telegram
    ../../modules/_new/common/whatsapp
    ../../modules/_new/common/wispr-flow
    ../../modules/_new/common/xcode
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
  networking.hostName = "lyng";
  home-manager.users.trond.home.stateVersion = "24.11";
}
