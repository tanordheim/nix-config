{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    go
    golangci-lint
    gotools
  ];

  home-manager.users.${config.username}.home.sessionVariables = {
    GOPATH = "$HOME/.local/share/go";
    GOPRIVATE = "github.com/${config.git.githubUsername},github.com/tibber";
  };
}
