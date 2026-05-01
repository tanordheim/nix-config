{
  imports = [
    ../../modules/darwin/_base.nix

    ../../modules/common/_1password
    ../../modules/darwin/aerospace
    ../../modules/common/android-studio
    ../../modules/common/atuin
    ../../modules/common/audacity
    ../../modules/common/camo
    ../../modules/common/chrome
    ../../modules/common/claude
    ../../modules/common/claude-desktop
    ../../modules/common/discord
    ../../modules/common/docker
    ../../modules/common/firefox
    ../../modules/common/gaming
    ../../modules/common/gdrive
    ../../modules/common/kitty
    ../../modules/common/linear
    ../../modules/common/logitech
    ../../modules/common/obsidian
    ../../modules/common/pdfexpert
    ../../modules/common/pocketcasts
    ../../modules/common/proton
    ../../modules/common/qmk
    ../../modules/common/raycast
    ../../modules/common/signal
    ../../modules/common/slack
    ../../modules/common/spotify
    ../../modules/common/syncthing
    ../../modules/common/teams
    ../../modules/common/telegram
    ../../modules/common/whatsapp
    ../../modules/darwin/wispr-flow
    ../../modules/common/xcode

    ../../modules/common/postgres
    ../../modules/common/redis
    ../../modules/common/kaf
    ../../modules/common/stern

    ../../modules/common/aws
    ../../modules/common/gcp
    ../../modules/common/kubernetes

    ../../modules/common/neovim
    ../../modules/common/jetbrains
    ../../modules/common/vscode

    ../../modules/common/rust-dev

    ../../modules/common/dotnet-dev
    ../../modules/common/go-dev
    ../../modules/common/html-dev
    ../../modules/common/java-dev
    ../../modules/common/kotlin-dev
    ../../modules/common/nix-dev
    ../../modules/common/node-dev
    ../../modules/common/protobuf-dev
    ../../modules/common/python-dev
    ../../modules/common/terraform-dev

    ../../modules/common/private
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
  networking.hostName = "lyng";
  home-manager.users.trond.home.stateVersion = "24.11";
}
