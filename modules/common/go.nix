{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go
    golangci-lint
    gotools
  ];

  environment.sessionVariables = {
    GOPATH = "$HOME/.local/share/go";
  };
}
