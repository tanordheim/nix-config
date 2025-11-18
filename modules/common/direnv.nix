{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.direnv = {
    enable = true;
    enableFishIntegration = false;
    enableNushellIntegration = false;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
