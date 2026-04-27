{ lib, ... }:
let
  inherit (lib) mkEnableOption;

  features = {
    _1password.enable = mkEnableOption "1Password";
    aerospace.enable = mkEnableOption "AeroSpace + sketchybar";
    android-studio.enable = mkEnableOption "Android Studio";
    audacity.enable = mkEnableOption "Audacity";
    atuin.enable = mkEnableOption "Atuin shell history sync";
    atuin-server.enable = mkEnableOption "Atuin sync server";
    aurral.enable = mkEnableOption "Aurral";
    aws.enable = mkEnableOption "AWS tooling";
    bazarr.enable = mkEnableOption "Bazarr";
    brave.enable = mkEnableOption "Brave";
    caddy.enable = mkEnableOption "Caddy reverse proxy";
    camo.enable = mkEnableOption "Camo Studio";
    chrome.enable = mkEnableOption "Google Chrome";
    chromium.enable = mkEnableOption "Chromium";
    claude.enable = mkEnableOption "Claude Code + skills";
    claude-desktop.enable = mkEnableOption "Claude Desktop";
    discord.enable = mkEnableOption "Discord";
    docker.enable = mkEnableOption "Docker";
    dotnet-dev.enable = mkEnableOption ".NET development tools";
    firefox.enable = mkEnableOption "Firefox";
    gcp.enable = mkEnableOption "GCP tooling";
    gdrive.enable = mkEnableOption "Google Drive";
    go-dev.enable = mkEnableOption "Go development tools";
    home-assistant.enable = mkEnableOption "Home Assistant";
    html-dev.enable = mkEnableOption "HTML development tools";
    hyprland.enable = mkEnableOption "Hyprland + hypr ecosystem";
    java-dev.enable = mkEnableOption "Java development tools";
    jetbrains.enable = mkEnableOption "JetBrains IDEs (ideavim hub)";
    kaf.enable = mkEnableOption "kaf (Kafka CLI)";
    kitty.enable = mkEnableOption "Kitty terminal";
    kotlin-dev.enable = mkEnableOption "Kotlin development tools";
    kubernetes.enable = mkEnableOption "Kubernetes tooling";
    lidarr.enable = mkEnableOption "Lidarr";
    linear.enable = mkEnableOption "Linear";
    logitech.enable = mkEnableOption "Logi Options+";
    mosquitto.enable = mkEnableOption "Mosquitto MQTT broker";
    neovim.enable = mkEnableOption "Neovim via nixvim";
    nix-dev.enable = mkEnableOption "Nix development tools";
    node-dev.enable = mkEnableOption "Node.js development tools";
    obsidian.enable = mkEnableOption "Obsidian";
    pdfexpert.enable = mkEnableOption "PDF Expert";
    plex.enable = mkEnableOption "Plex";
    pocketcasts.enable = mkEnableOption "Pocket Casts";
    postgres.enable = mkEnableOption "PostgreSQL (pgcli)";
    proton.enable = mkEnableOption "Proton Mail";
    protobuf-dev.enable = mkEnableOption "Protobuf development tools";
    prowlarr.enable = mkEnableOption "Prowlarr";
    python-dev.enable = mkEnableOption "Python development tools";
    qbittorrent.enable = mkEnableOption "qBittorrent";
    qmk.enable = mkEnableOption "QMK keyboard tooling";
    radarr.enable = mkEnableOption "Radarr";
    raycast.enable = mkEnableOption "Raycast";
    redis.enable = mkEnableOption "Redis";
    rust-dev.enable = mkEnableOption "Rust development tools";
    sabnzbd.enable = mkEnableOption "SABnzbd";
    seerr.enable = mkEnableOption "Seerr";
    signal.enable = mkEnableOption "Signal";
    slack.enable = mkEnableOption "Slack";
    sonarr.enable = mkEnableOption "Sonarr";
    spotify.enable = mkEnableOption "Spotify";
    stern.enable = mkEnableOption "stern (Kubernetes log tail)";
    stylix.enable = mkEnableOption "Stylix theming";
    teams.enable = mkEnableOption "Microsoft Teams";
    telegram.enable = mkEnableOption "Telegram";
    terraform-dev.enable = mkEnableOption "Terraform development tools";
    unpackerr.enable = mkEnableOption "Unpackerr";
    whatsapp.enable = mkEnableOption "WhatsApp";
    vscode.enable = mkEnableOption "VSCode";
    wezterm.enable = mkEnableOption "WezTerm";
    wispr-flow.enable = mkEnableOption "Wispr Flow";
    xcode.enable = mkEnableOption "Xcode helpers";
    zigbee2mqtt.enable = mkEnableOption "Zigbee2MQTT";
  };

  hostOptions = {
    options.host.features = features;
  };
in
{
  flake.modules.darwin.hostOptions = hostOptions;
  flake.modules.nixos.hostOptions = hostOptions;
  flake.modules.homeManager.hostOptions = hostOptions;
}
