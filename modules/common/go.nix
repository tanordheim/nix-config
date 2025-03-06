{ pkgs, config, ... }:
{
  home-manager.users.${config.username} = {
    programs.go = {
      enable = true;
      package = pkgs.go_1_24;

      goPath = ".local/share/go";
      goBin = ".local/bin";
      goPrivate = [
        "github.com/${config.git.githubUsername}"
        "github.com/tibber"
      ];
    };

    home.packages = with pkgs; [
      golangci-lint
      gotools
    ];
  };
}
