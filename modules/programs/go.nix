{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go
    golangci-lint
    gotools
  ];
}
