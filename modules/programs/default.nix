{ pkgs, ... }:
{
  imports = [
    ./1password
    ./aws-vpn
    ./brave
    ./docker
    ./dotnet
    ./firefox
    ./jetbrains
    ./linear
    ./signal
    ./slack
    ./telegram

    ./alacritty.nix
    ./chrome.nix
    ./git.nix
    ./go.nix
    ./kaf.nix
    ./kubectl.nix
    ./neovim.nix
    ./ssh.nix
    ./starship.nix
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
