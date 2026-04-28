{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (config.flake.modules) darwin homeManager;
in
{
  configurations.darwin.lyng.module =
    { config, ... }:
    {
      imports = [
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-homebrew.darwinModules.nix-homebrew
        inputs.stylix.darwinModules.stylix
      ]
      ++ lib.attrValues darwin;

      home-manager.users.trond = {
        imports = (lib.attrValues homeManager) ++ [
          inputs.nix-config-private.homeManagerModules.default
        ];
        host.features = config.host.features;
      };

      nixpkgs.hostPlatform = "aarch64-darwin";
      system.stateVersion = 5;
      system.primaryUser = "trond";
      networking.hostName = "lyng";
      home-manager.users.trond.home.stateVersion = "24.11";

      host.features = {
        _1password.enable = true;
        aerospace.enable = true;
        atuin.enable = true;
        android-studio.enable = true;
        audacity.enable = true;
        aws.enable = true;
        camo.enable = true;
        chrome.enable = true;
        claude.enable = true;
        claude-desktop.enable = true;
        discord.enable = true;
        docker.enable = true;
        dotnet-dev.enable = true;
        firefox.enable = true;
        gaming.enable = true;
        gcp.enable = true;
        gdrive.enable = true;
        go-dev.enable = true;
        html-dev.enable = true;
        java-dev.enable = true;
        jetbrains.enable = true;
        kaf.enable = true;
        kitty.enable = true;
        kotlin-dev.enable = true;
        kubernetes.enable = true;
        linear.enable = true;
        logitech.enable = true;
        neovim.enable = true;
        nix-dev.enable = true;
        node-dev.enable = true;
        obsidian.enable = true;
        pdfexpert.enable = true;
        pocketcasts.enable = true;
        postgres.enable = true;
        proton.enable = true;
        protobuf-dev.enable = true;
        python-dev.enable = true;
        qmk.enable = true;
        raycast.enable = true;
        redis.enable = true;
        rust-dev.enable = true;
        signal.enable = true;
        slack.enable = true;
        spotify.enable = true;
        stern.enable = true;
        stylix.enable = true;
        teams.enable = true;
        telegram.enable = true;
        terraform-dev.enable = true;
        vscode.enable = true;
        wezterm.enable = true;
        whatsapp.enable = true;
        wispr-flow.enable = true;
        xcode.enable = true;
      };
    };
}
