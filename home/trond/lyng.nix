{ inputs, ... }:
{
  imports = [
    ./global

    # dev
    ./features/dev/nix
    ./features/dev/go
    ./features/dev/go/ide.nix
    ./features/dev/dotnet
    ./features/dev/dotnet/vscode.nix
    ./features/dev/dotnet/ide.nix
    ./features/dev/rust
    ./features/dev/java
    ./features/dev/node
    ./features/dev/python
    ./features/dev/python/ide.nix
    ./features/dev/terraform
    ./features/dev/html
    ./features/dev/protobuf
    ./features/dev/kotlin
    ./features/dev/xcode
    ./features/dev/postgres
    ./features/dev/redis

    # cloud
    ./features/cloud/aws.nix
    ./features/cloud/google.nix
    ./features/cloud/kubernetes.nix
    ./features/cloud/kaf.nix
    ./features/cloud/stern.nix

    # terminals
    ./features/terminals/kitty.nix
    ./features/terminals/wezterm.nix

    # desktop
    ./features/desktop/aerospace

    # browsers
    ./features/browsers/firefox.nix

    # apps
    ./features/1password.nix
    ./features/claude
    ./features/qmk.nix
    ./features/media/audacity.nix
    ./features/telegram.nix

    # private
    inputs.nix-config-private.homeManagerModules.default
  ];
}
