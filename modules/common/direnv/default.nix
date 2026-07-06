{ isDarwin, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.direnv = {
          enable = true;
          enableFishIntegration = false;
          enableNushellIntegration = false;
          enableZshIntegration = true;
          nix-direnv.enable = true;
          config.whitelist.prefix = [
            "${config.home.homeDirectory}/${if isDarwin then "Code" else "code"}/"
          ];
        };
      }
    )
  ];
}
