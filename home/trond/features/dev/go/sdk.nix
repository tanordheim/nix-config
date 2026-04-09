{ pkgs, config, ... }:
{
  programs.go = {
    enable = true;
    package = pkgs.go;

    env = {
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
      GOBIN = "${config.home.homeDirectory}/.local/bin";
      GOPRIVATE = [
        "github.com/tanordheim"
      ];
    };
  };

  home.packages = with pkgs; [
    golangci-lint
    gotools
  ];
}
