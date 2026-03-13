{ pkgs, config, ... }:
{
  home-manager.users.${config.username} = {
    programs.go = {
      enable = true;
      package = pkgs.go;

      env = {
        GOPATH = "$HOME/.local/share/go";
        GOBIN = "$HOME/.local/bin";
        GOPRIVATE = [
          "github.com/${config.git.githubUsername}"
        ];
      };
    };

    home.packages = with pkgs; [
      golangci-lint
      gotools
    ];
  };
}
