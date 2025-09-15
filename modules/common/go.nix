{ pkgs, config, ... }:
{
  home-manager.users.${config.username} = {
    programs.go = {
      enable = true;
      package = pkgs.go_1_24;

      env = {
        GOPATH = ".local/share/go";
        GOBIN = ".local/bin";
        GOPRIVATE = [
          "github.com/${config.git.githubUsername}"
          "github.com/tibber"
        ];
      };
    };

    home.packages = with pkgs; [
      golangci-lint
      gotools
    ];
  };
}
