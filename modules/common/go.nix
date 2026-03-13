{ pkgs, config, ... }:
let
  githubUsername = config.git.githubUsername;
in
{
  home-manager.users.${config.username} = { config, ... }: {
    programs.go = {
      enable = true;
      package = pkgs.go;

      env = {
        GOPATH = "${config.home.homeDirectory}/.local/share/go";
        GOBIN = "${config.home.homeDirectory}/.local/bin";
        GOPRIVATE = [
          "github.com/${githubUsername}"
        ];
      };
    };

    home.packages = with pkgs; [
      golangci-lint
      gotools
    ];
  };
}
