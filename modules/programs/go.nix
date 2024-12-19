{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    go
    golangci-lint
    gotools
  ];

  environment.sessionVariables = {
    GOPATH = "${config.my.osUser.home}/.local/share/go";
  };
}
