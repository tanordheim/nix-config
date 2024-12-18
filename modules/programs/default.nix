{ pkgs, ... }:
{
  imports = [
    ./1password
    ./aws-vpn
    ./brave
    ./chromium
    ./discord
    ./docker
    ./dotnet
    ./firefox
    ./jetbrains
    ./linear
    ./neovim
    ./obsidian
    ./slack

    ./alacritty.nix
    ./git.nix
    ./go.nix
    ./kaf.nix
    ./kubectl.nix
    ./node.nix
    ./signal.nix
    ./ssh.nix
    ./starship.nix
    ./telegram.nix
    ./terraform.nix
    ./zsh.nix
  ];

  environment.systemPackages = with pkgs; [
    cmake
    coreutils
    curl
    diffutils
    file
    findutils
    gawk
    gcc
    gnugrep
    gnumake
    gnupatch
    gnused
    gnutar
    gzip
    jq
    killall
    lsof
    unixtools.watch
    unzip
    zip
  ];
}
