{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    go
    golangci-lint
    gotools
  ];

  environment.sessionVariables = {
    GOPATH = "$HOME/.local/share/go";
    GOPRIVATE = "github.com/${config.git.githubUsername},github.com/tibber";
  };
}
