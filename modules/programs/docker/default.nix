{ pkgs, lib, isDarwin, ... }:
{
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];

  imports = lib.optionals isDarwin [ ./_darwin.nix ];
}
